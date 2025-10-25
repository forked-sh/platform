# frozen_string_literal: true

module Forked
  module Repos
    class UserRepo < Forked::DB::Repo
      commands :create, update: :by_pk, delete: :by_pk

      def all
        users.combine(:namespaces).to_a
      end

      def find_by_id(id)
        users.where(id: id).one
      end

      def find_by_email_address(email_address)
        users.where(email_address: email_address).one
      end

      def find_by_username(username)
        users.where(username: username).one
      end

      def valid_password?(user, password)
        if Argon2::Password.verify_password(password, user.password_hash)
          true
        else
          false
        end
      end

      # def find_by_id!(id)
      #   users.where(id: id).one!
      # end

      # def find_by_email_address!(email_address)
      #   users.where(email_address: email_address).one!
      # end
    end
  end
end
