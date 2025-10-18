# frozen_string_literal: true

module Forked
  class Routes < Hanami::Routes
    root to: "home.index"
    # Add your routes here. See https://guides.hanamirb.org/routing/overview/ for details.
    get "/home", to: "home.index"
  end
end
