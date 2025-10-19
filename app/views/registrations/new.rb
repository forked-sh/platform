# frozen_string_literal: true

module Forked
  module Views
    module Registrations
      class New < Forked::UnauthenticatedView
        expose :invite_code do
          Forked::Operations::Users::Register::INVITE_CODE if Hanami.env == :development
        end

        expose :values, default: { registration: {} }
      end
    end
  end
end
