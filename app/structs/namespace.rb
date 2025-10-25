# frozen_string_literal: true

module Forked
  module Structs
    class Namespace < Forked::DB::Struct
      attribute? :owner, Types::Any
    end
  end
end
