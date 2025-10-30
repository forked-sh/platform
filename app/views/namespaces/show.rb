# frozen_string_literal: true

module Forked
  module Views
    module Namespaces
      class Show < Forked::View
        expose :namespace

        expose :organization, default: nil
        expose :user, default: nil
      end
    end
  end
end
