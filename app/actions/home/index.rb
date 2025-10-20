# frozen_string_literal: true

module Forked
  module Actions
    module Home
      class Index < Forked::Action
        def handle(request, response)
          response.redirect_to(routes.path(:dashboard)) if response[:current_user]
        end
      end
    end
  end
end
