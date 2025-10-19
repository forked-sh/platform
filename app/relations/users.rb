# frozen_string_literal: true

module Forked
  module Relations
    class Users < Forked::DB::Relation
      schema :users, infer: true
    end
  end
end
