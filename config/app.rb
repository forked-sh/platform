# frozen_string_literal: true

require "hanami"
# require "rouge"

# Use the default colorizer instead of rouge to avoid stack overflow issues
# Dry::Monitor::SQL::Logger.load_extensions(:rouge_colorizer)

module Forked
  class App < Hanami::App
    environment(:development) do
      require_relative "../lib/hanami/providers/db_logging"

      config.logger.options[:colorize] = true

      config.logger.template = <<~TMPL
        [<blue>%<progname>s</blue>] [%<severity>s] [<green>%<time>s</green>] %<message>s %<payload>s
      TMPL
    end

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
