# frozen_string_literal: true

module Forked
  module Repos
    class OrganizationRepo < Forked::DB::Repo
      commands :create, update: :by_pk, delete: :by_pk

      def all
        organizations.combine(:namespaces).to_a
      end

      def find_by_name(name)
        organizations.where(name: name).one
      end
    end
  end
end
