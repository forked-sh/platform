# frozen_string_literal: true

require "argon2"

module Forked
  module Operations
    module Users
      class SignIn < Forked::Operation
        include Deps["repos.user_repo"]

        def call(email_address:, password:)
          user = step find_user(email_address)
          step validate_password(user, password)
        end

        private

        def find_user(email_address)
          user = user_repo.find_by_email_address(email_address)
          return Failure(:user_not_found) unless user

          Success(user)
        end

        def validate_password(user, password)
          if user_repo.valid_password?(user, password)
            Success(user)
          else
            Failure(:invalid_password)
          end
        end
      end
    end
  end
end
