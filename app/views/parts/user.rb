# auto_register: false
# frozen_string_literal: true

module Forked
  module Views
    module Parts
      class User < Forked::Views::Part
        def avatar_url
          "https://avatars.laravel.cloud/#{email_address.gsub(".sh", "sh")}"
        end
      end
    end
  end
end
