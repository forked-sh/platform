# frozen_string_literal: true

module Forked
  module Relations
    class Namespaces < Forked::DB::Relation
      schema :namespaces, infer: true do
        associations do
          belongs_to :user, as: :user, foreign_key: :owner_id, view: :for_namespaces
          belongs_to :organization, as: :organization, foreign_key: :owner_id, view: :for_namespaces
          # belongs_to :owner, foreign_key: :owner_id, foreign_type: :owner_type
        end
      end

      def for_users
        where(owner_type: "User")
      end

      def for_organizations
        where(owner_type: "Organization")
      end
    end
  end
end
