# frozen_string_literal: true

module Forked
  module Structs
    class Namespace < Forked::DB::Struct
      attribute? :owner, Types::Any


      def organization?
        owner_type == "Organization"
      end

      def user?
        owner_type == "User"
      end
    end
  end
end
