require "argon2"

module Forked
  module Utils
    class Hasher < Argon2::Password
    end
  end
end
