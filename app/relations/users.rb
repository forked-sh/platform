# frozen_string_literal: true

module Forked
  module Relations
    class Users < Forked::DB::Relation
      schema :users, infer: true do
        associations do
          has_many :namespaces, as: :namespaces, foreign_key: :owner_id, view: :for_users
        end
      end

      def for_namespaces(namespaces)
        by_pk(namespaces.select { |namespace| namespace[:owner_type] == 'User' }.map { |namespace| namespace[:owner_id] })
      end
    end
  end
end
