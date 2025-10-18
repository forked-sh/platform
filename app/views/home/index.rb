# frozen_string_literal: true

module Forked
  module Views
    module Home
      class Index < Forked::MarketingView
        expose :page_title do
          "Welcome to Forked.sh"
        end
      end
    end
  end
end
