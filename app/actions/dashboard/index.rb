# frozen_string_literal: true

module Forked
  module Actions
    module Dashboard
      class Index < Forked::Action
        require_authenticated_user!

        def handle(request, response)
        end
      end
    end
  end
end
