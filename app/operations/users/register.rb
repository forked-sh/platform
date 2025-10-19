# frozen_string_literal: true

module Forked
  module Operations
    module Users
      class Register < Forked::Operation
        include Deps["repos.user_repo", "utils.hasher"]

        INVITE_CODE = "afomera-invite-only-code"

        def call(params)
          step validate_invite_code(params[:invite_code], INVITE_CODE)
          step validate_unique_username(params[:username])
          step validate_no_existing_email(params[:email_address])
          step validate_name(params[:name])
          step create_account(params)
        rescue StandardError => e
          Failure(message: "Registration failed: #{e.message}")
        end

        private

        def validate_name(name)
          if name.strip.empty?
            Failure(:invalid_name)
          else
            Success()
          end
        end

        def validate_invite_code(provided_code, valid_code)
          if provided_code == valid_code
            Success()
          else
            Failure(:invalid_invite_code)
          end
        end

        def validate_no_existing_email(email_address)
          return Failure(:email_already_exists) if user_repo.find_by_email_address(email_address)

          Success()
        end

        def validate_unique_username(username)
          return Failure(:username_taken) if user_repo.find_by_username(username)

          Success()
        end

        def create_account(params)
          hashed_password = hasher.create(params[:password])

          user = user_repo.create(
            name: params[:name],
            username: params[:username],
            email_address: params[:email_address],
            password_hash: hashed_password
          )

          Success(user)

        rescue ROM::SQL::UniqueConstraintViolation
          Failure(:registration_failed)
        end
      end
    end
  end
end
