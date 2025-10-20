# frozen_string_literal: true

module Forked
  module Actions
    module Dashboard
      class Index < Forked::Action
        require_authenticated_user!

        include Deps["repos.user_repo"]

        def handle(request, response)
          response[:current_user] = user_repo.find_by_id(request.session["user_id"])
        end
      end
    end
  end
end
