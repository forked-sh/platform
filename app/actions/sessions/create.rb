# frozen_string_literal: true

module Forked
  module Actions
    module Sessions
      class Create < Forked::Action
        include Deps["operations.users.sign_in"]

        params do
          required(:session).schema do
            required(:email_address).filled(:string)
            required(:password).filled(:string)
          end
        end

        def handle(request, response)
          render_on_invalid_params(response, view, message: "Invalid email or password.")

          case sign_in.call(
            email_address: request.params[:session][:email_address],
            password: request.params[:session][:password]
          )
          in Success(user)
            response.flash[:notice] = "Successfully logged in."
            response.cookies[:user_id] = user.id

            response.redirect_to routes.path(:new_session) # TODO: change to root or dashboard
          else
            response.flash.now[:error] = "Invalid email or password."
            response.status = 422
          end
        end
      end
    end
  end
end
