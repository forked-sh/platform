# frozen_string_literal: true

require "hanami"

module Forked
  class App < Hanami::App
    config.logger.filters = config.logger.filters + ["password_hash"]

    config.actions.sessions = :cookie, {
      key: "forked-sh.session",
      secret: settings.session_secret,
      expire_after: 60 * 60 * 24 * 365 # 1 year
    }

    # config.actions.cookies = {
    #   secure: Hanami.env == :production,
    #   httponly: true,
    #   secret: settings.session_secret
    # }
  end
end
