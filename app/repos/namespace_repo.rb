# frozen_string_literal: true

module Forked
  module Repos
    class NamespaceRepo < Forked::DB::Repo
      commands :create, update: :by_pk, delete: :by_pk

      def all
        namespaces.to_a
      end

      def find_by_name(name)
        namespaces.where(name: name).one
      end

      def all_with_owner
        all_namespaces = namespaces.to_a

        user_ids = all_namespaces.select { |ns| ns.owner_type == "User" }.map(&:owner_id).compact
        org_ids = all_namespaces.select { |ns| ns.owner_type == "Organization" }.map(&:owner_id).compact

        users_data = user_ids.empty? ? {} : users.by_pk(user_ids).to_a.to_h { |u| [u[:id], u] }
        orgs_data = org_ids.empty? ? {} : organizations.by_pk(org_ids).to_a.to_h { |o| [o[:id], o] }

        all_namespaces.map do |namespace|
          owner = if namespace.owner_type == "User"
            users_data[namespace.owner_id]
          else
            orgs_data[namespace.owner_id]
          end

          # Define a singleton method on this namespace instance to access owner
          namespace.define_singleton_method(:owner) { owner }
          namespace
        end
      end

      def find_by_name_with_owner(name)
        namespace = namespaces.where(name: name).one
        return nil unless namespace

        owner = if namespace.owner_type == "User"
          users.by_pk(namespace.owner_id).one
        else
          organizations.by_pk(namespace.owner_id).one
        end

        # Define a singleton method on this namespace instance to access owner
        namespace.define_singleton_method(:owner) { owner }
        namespace
      end

      private

      def users
        root.users
      end

      def organizations
        root.organizations
      end
    end
  end
end
