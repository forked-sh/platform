# frozen_string_literal: true

module Forked
  module Actions
    module Sessions
      class Create < Forked::Action
        params do
          required(:session).schema do
            required(:email_address).filled(:string)
            required(:password).filled(:string)
          end
        end

        def handle(request, response)
          render_on_invalid_params(response, view, message: "Invalid email or password.")

          response.flash[:notice] = "Successfully logged in."
          response.redirect_to routes.path(:new_session) # TODO: change to root or dashboard
        end
      end
    end
  end
end
