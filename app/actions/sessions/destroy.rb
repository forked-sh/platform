# frozen_string_literal: true

module Forked
  module Actions
    module Sessions
      class Destroy < Forked::Action
        def handle(request, response)
          response.session[:user_id] = nil
          response.flash[:notice] = "Successfully logged out."
          response.redirect_to routes.path(:root)
        end
      end
    end
  end
end
