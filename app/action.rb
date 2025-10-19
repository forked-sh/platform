# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"

module Forked
  class Action < Hanami::Action
    # Provide `Success` and `Failure` for pattern matching on operation results
    include Dry::Monads[:result]

    private

    def render_on_failure(response, template, message: "An error occurred.")
      response.flash.now[:error] = message
      body = response.render(template, values: response.request.params.to_h, errors: response.request.params.errors)
      halt(400, body)
    end

    def render_on_invalid_params(response, template, message: "Invalid parameters.")
      if !response.request.params.valid?
        response.flash.now[:error] = message
        body = response.render(template, values: response.request.params.to_h, errors: response.request.params.errors)
        halt(422, body)
      end
    end

    # TODO: Make this work better!
    # def validate_browser_version(request, _response)
    #   require "user_agent"

    #   user_agent = UserAgent.parse(request.user_agent)
    #   if user_agent.browser == "Internet Explorer" && user_agent.version.to_i < 11
    #     halt 400, "Your browser is not supported."
    #   else
    #     halt 406, "Please update your browser." if user_agent.browser == "Safari" && user_agent.version.to_s.to_i <= 24
    #   end
    # end
  end
end
