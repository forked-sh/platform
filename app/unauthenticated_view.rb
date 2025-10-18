# auto_register: false
# frozen_string_literal: true

require "hanami/view"

module Forked
  class UnauthenticatedView < Hanami::View
    config.layout = "unauthenticated"
  end
end
