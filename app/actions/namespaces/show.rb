# frozen_string_literal: true

module Forked
  module Actions
    module Namespaces
      class Show < Forked::Action
        include Deps["repos.namespace_repo", "repos.user_repo", "repos.organization_repo"]

        def handle(request, response)
          namespace_name = request.params[:namespace]
          namespace = namespace_repo.find_by_name(namespace_name)

          if namespace
            organization = organization_repo.find_by_name(namespace.name) if namespace.organization?
            user = user_repo.find_by_username(namespace.name) if namespace.user?

            response.render(view, namespace: namespace, organization: organization, user: user)
          else
            response.status = 404
            response.body = "Namespace not found"
          end
        end
      end
    end
  end
end
