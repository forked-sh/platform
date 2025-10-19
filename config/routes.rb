# frozen_string_literal: true

module Forked
  class Routes < Hanami::Routes
    # Add your routes here. See https://guides.hanamirb.org/routing/overview/ for details.
    root to: "home.index"

    get "/session/new", to: "sessions.new", as: :new_session
    post "/session", to: "sessions.create", as: :create_session
    get "/registrations/new", to: "registrations.new", as: :new_registration
    post "/registrations", to: "registrations.create", as: :create_registration
  end
end
