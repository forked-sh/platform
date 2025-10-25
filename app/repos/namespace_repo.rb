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
    end
  end
end
