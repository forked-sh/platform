# frozen_string_literal: true

module Forked
  module Actions
    module Registrations
      class Create < Forked::Action
        include Deps[register_user: "operations.users.register"]

        params do
          required(:registration).schema do
            required(:name).filled(:string, min_size?: 2, max_size?: 100)
            required(:username).filled(:string, min_size?: 3, max_size?: 30)
            required(:email_address).filled(:string, format?: /@/)
            required(:password).filled(:string, min_size?: 8, max_size?: 72)
            required(:invite_code).filled(:string)
          end
        end

        def handle(request, response)
          render_on_invalid_params(response, view, message: "Please correct the errors: \n #{request.params.error_messages.join(', ')}")

          case register_user.call(request.params[:registration].to_h)
          in Success(user)
            response.status = 201
            response.body = "User #{user.username} created successfully."
          in Failure(:invalid_invite_code)
            render_on_failure(response, view, message: "The invite code provided is invalid.")
          in Failure(:username_taken)
            render_on_failure(response, view, message: "The username is already taken.")
          in Failure(:email_address_taken)
            render_on_failure(response, view, message: "The email address is already taken.")
          else
            render_on_failure(response, view, message: "Registration failed.")
          end
        end
      end
    end
  end
end
