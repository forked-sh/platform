# frozen_string_literal: true

module Forked
  class Routes < Hanami::Routes
    # Add your routes here. See https://guides.hanamirb.org/routing/overview/ for details.
    root to: "home.index"

    get "/session/new", to: "sessions.new", as: :new_session
    post "/session", to: "sessions.create", as: :create_session
    delete "/session", to: "sessions.destroy", as: :destroy_session

    get "/registrations/new", to: "registrations.new", as: :new_registration
    post "/registrations", to: "registrations.create", as: :create_registration

    get "/dashboard", to: "dashboard.index", as: :dashboard
    get "/user/issues", to: "user.issues.index", as: :user_issues
    get "/user/pull_requests", to: "user.pull_requests.index", as: :user_pull_requests

    scope "/account" do
      get "/settings", to: "account.settings.edit", as: :settings_edit
      patch "/settings", to: "account.settings.update", as: :settings_update

      # SSH Keys
      get "/ssh_keys", to: "account.ssh_keys.index", as: :ssh_keys
      get "/ssh_keys/new", to: "account.ssh_keys.new", as: :ssh_key_new
      post "/ssh_keys", to: "account.ssh_keys.create", as: :ssh_keys_create
    end

    # Namespaces
    get "/:namespace", to: "namespaces.show", as: :namespace
    get "/:namespace/:repository", to: "repositories.show", as: :repository

    get "/:namespace/:repository/issues", to: "repositories.issues.index", as: :repository_issues
    get "/:namespace/:repository/pull_requests", to: "repositories.pull_requests.index", as: :repository_pull_requests

    slice :live_reload, at: "/__live_reload__" do
    end
  end
end
