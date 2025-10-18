# frozen_string_literal: true

require "hanami"

module Forked
  class App < Hanami::App
    config.actions.sessions = :cookie, {
      key: "forked-sh.session",
      secret: settings.session_secret,
      expire_after: 60 * 60 * 24 * 365 # 1 year
    }
  end
end
