# frozen_string_literal: true

module Forked
  module Structs
    class Organization < Forked::DB::Struct
      def email_address
        name.gsub(" ", ".").downcase + "@forked.sh"
      end

      def avatar_url
        "https://avatars.laravel.cloud/#{email_address.gsub(".sh", "-sh")}"
      end
    end
  end
end
