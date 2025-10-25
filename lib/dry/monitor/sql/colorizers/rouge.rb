# frozen_string_literal: true

module Dry
  module Monitor
    module SQL
      module Colorizers
        class Rouge
          def initialize(theme = nil)
            @theme = theme || :monokai
            ensure_rouge_loaded
          end

          def call(query)
            return query unless colorize?

            # Use Rouge to highlight SQL syntax
            lexer = ::Rouge::Lexers::SQL.new
            formatter = ::Rouge::Formatters::Terminal256.new(@theme)
            formatter.format(lexer.lex(query))
          rescue StandardError => e
            # Fallback to plain query if Rouge fails
            warn "Rouge colorization failed: #{e.message}"
            query
          end

          private

          def colorize?
            $stdout.tty? && rouge_available?
          end

          def rouge_available?
            @rouge_available ||= begin
              require "rouge"
              true
            rescue LoadError
              false
            end
          end

          def ensure_rouge_loaded
            unless rouge_available?
              raise LoadError, "Rouge gem is required for SQL syntax highlighting. Add 'gem \"rouge\"' to your Gemfile."
            end
          end
        end
      end
    end
  end
end
