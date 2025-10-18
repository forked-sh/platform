# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"

module Forked
  class Action < Hanami::Action
    # Provide `Success` and `Failure` for pattern matching on operation results
    include Dry::Monads[:result]

    private

    def render_on_invalid_params(response, template, message: "Invalid parameters.")
      if !response.request.params.valid?
        response.flash.now[:error] = message
        body = response.render(template, values: response.request.params.to_h, errors: response.request.params.errors)
        halt(422, body)
      end
    end

    def handle_invalid_params(request, response)
      response.flash[:error] = "Invalid email or password."
      response.status = 422
    end
  end
end
