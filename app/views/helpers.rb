# auto_register: false
# frozen_string_literal: true

require_relative "helpers/form_helper"

module Forked
  module Views
    module Helpers
      include FormHelper

      # Add your view helpers here
      def nav_link_class(page)
        base_classes = "text-secondary hover:text-primary transition-color"
        active_classes = "text-primary underline underline-offset-[12px] decoration-2"
        current_page = request.path_info.start_with?("/#{page}")

        if current_page
          active_classes
        else
          base_classes
        end
      end
    end
  end
end
