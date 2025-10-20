# auto_register: false

module Forked
  module Views
    class Context < Hanami::View::Context
      include Deps["repos.user_repo"]

      def current_user
        return nil unless session["user_id"]

        @current_user ||= user_repo.get(session["user_id"])
      end
    end
  end
end
