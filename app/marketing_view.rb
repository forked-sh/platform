# auto_register: false
# frozen_string_literal: true

require "hanami/view"

module Forked
  class MarketingView < Forked::View
    config.layout = "marketing"
  end
end
