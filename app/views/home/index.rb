# frozen_string_literal: true

module Forked
  module Views
    module Home
      class Index < Forked::View
        config.layout = "marketing"

        expose :page_title do
          "Welcome to Forked.sh"
        end
      end
    end
  end
end
