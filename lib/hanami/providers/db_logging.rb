module Hanami
  module Providers
    # @api private
    # @since 2.2.0
    class DBLogging < Hanami::Provider::Source
      # @api private
      # @since 2.2.0
      def prepare
        require_relative "../../dry/monitor/sql/logger"

        slice["notifications"].register_event :sql
      end

      # @api private
      # @since 2.2.0
      def start
        logger = Dry::Monitor::SQL::Logger.new(slice["logger"])

        # Load Rouge colorizer if available
        begin
          logger.class.load_extensions(:rouge_colorizer)
        rescue LoadError
          # Fallback to default colorizer if Rouge is not available
          logger.class.load_extensions(:default_colorizer)
        end

        logger.subscribe(slice["notifications"])
      end
    end
  end
end
