# auto_register: false
# frozen_string_literal: true

require "hanami/view"

module Forked
  class View < Hanami::View
    expose :current_user
  end
end
