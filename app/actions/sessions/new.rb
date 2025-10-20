# frozen_string_literal: true

module Forked
  module Actions
    module Sessions
      class New < Forked::Action
        require_unauthenticated_user!

        def handle(request, response)
        end
      end
    end
  end
end
