# frozen_string_literal: true

require "hanami"
# require "rouge"

# Use the default colorizer instead of rouge to avoid stack overflow issues
# Dry::Monitor::SQL::Logger.load_extensions(:rouge_colorizer)
# 
    require 'json'
    require 'listen'

    class LiveReloadMiddleware
      def initialize(app, options = {})
        @app = app
        @watch_paths = options[:paths] || ['app/assets', "app/templates", 'public/assets']
        @last_modified = Time.now.to_f
        setup_listener
      end

      def call(env)
        if env['PATH_INFO'] == '/__live_reload__'
          handle_live_reload_request
        else
          @app.call(env)
        end
      end

      private

      def handle_live_reload_request
        [
          200,
          {
            'Content-Type' => 'application/json',
            'Cache-Control' => 'no-cache'
          },
          [JSON.generate({ modified: @last_modified })]
        ]
      end

      def setup_listener
        @listener = Listen.to(*@watch_paths, relative: true) do |modified, added, removed|
          @last_modified = Time.now.to_f
          puts "[Live Reload] Detected changes: #{(modified + added + removed).join(', ')}"
        end
        @listener.start
      end
    end

module Forked
  class App < Hanami::App
    environment(:development) do
      require_relative "../lib/hanami/providers/db_logging"

      config.logger.options[:colorize] = true

      config.logger.template = <<~TMPL
        [<blue>%<progname>s</blue>] [%<severity>s] [<green>%<time>s</green>] %<message>s %<payload>s
      TMPL

      config.middleware.use LiveReloadMiddleware, paths: ['app/assets', "app/templates", 'public/assets']
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
