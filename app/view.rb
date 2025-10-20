# auto_register: false
# frozen_string_literal: true

require "hanami/view"

module Forked
  class View < Hanami::View
    expose :current_user

    def layout_locals(args)
      super.merge(
        current_user: args[:current_user]
      )
    end
  end
end
