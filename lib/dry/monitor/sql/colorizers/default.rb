# frozen_string_literal: true

module Dry
  module Monitor
    module SQL
      module Colorizers
        class Default
          KEYWORD_PATTERN = /\b(SELECT|FROM|WHERE|JOIN|LEFT|RIGHT|INNER|OUTER|ORDER BY|GROUP BY|HAVING|LIMIT|OFFSET|INSERT|UPDATE|DELETE|CREATE|ALTER|DROP|AND|OR|NOT|NULL|AS|ON|IN|EXISTS|BETWEEN|LIKE|DISTINCT|COUNT|SUM|AVG|MAX|MIN)\b/i

          COLORS = {
            keyword: "\e[35m",    # Magenta
            string: "\e[32m",     # Green
            number: "\e[33m",     # Yellow
            reset: "\e[0m"        # Reset
          }.freeze

          def initialize(theme = nil)
            @theme = theme
          end

          def call(query)
            return query unless colorize?

            colorized = query.dup

            # Colorize keywords
            colorized.gsub!(KEYWORD_PATTERN) do |match|
              "#{COLORS[:keyword]}#{match}#{COLORS[:reset]}"
            end

            # Colorize strings
            colorized.gsub!(/'[^']*'/) do |match|
              "#{COLORS[:string]}#{match}#{COLORS[:reset]}"
            end

            # Colorize numbers
            colorized.gsub!(/\b\d+\b/) do |match|
              "#{COLORS[:number]}#{match}#{COLORS[:reset]}"
            end

            colorized
          end

          private

          def colorize?
            $stdout.tty?
          end
        end
      end
    end
  end
end
