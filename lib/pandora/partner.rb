require 'pandora/util/client'
require 'pandora/util/cryptor'

module Pandora
  class Partner
    include Client

    attr_reader :username, :password, :device, :encryption_key, :decryption_key
    attr_reader :partner_id, :partner_auth_token, :time_offset

    def initialize(username, password, device, encryption_key, decryption_key)
      @username, @password, @device, @encryption_key, @decryption_key =
        username, password, device, encryption_key, decryption_key
      authenticate
    end

    def reauthenticate
      authenticate
    end

    def login_user(username, password)
      User.new(self, username, password)
    end

    def marshal_dump
      [@username, @password, @device, @encryption_key, @decryption_key,
        @partner_id, @partner_auth_token, @time_offset]
    end

    def marshal_load(objects)
      @username, @password, @device, @encryption_key, @decryption_key,
        @partner_id, @partner_auth_token, @time_offset = objects
    end


   private

    def cryptor
      @cryptor ||= Cryptor.new(@encryption_key, @decryption_key)
    end

    def authenticate
      result = call 'auth.partnerLogin', { secure: true, encrypt: false }, {
        username:    @username,
        password:    @password,
        deviceModel: @device,
        version:     '5'
      }

      @partner_id = result['partnerId']
      @partner_auth_token = result['partnerAuthToken']
      server_time = cryptor.decrypt(result['syncTime'])[4..-1].to_i
      @time_offset = Time.now.to_i - server_time
    end

    def user_auth_token
      nil
    end

    def user_id
      nil
    end
  end
end
