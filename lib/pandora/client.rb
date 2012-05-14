require 'pandora/cryptor'
require 'pandora/errors'
require 'faraday'
require 'json' unless defined?(JSON)

module Pandora

  # Standardized Tuner API calls
  #
  # Expects the target class to respond to the following methods:
  #   cryptor
  #   user_auth_token
  #   partner_auth_token
  #   partner_id
  #   user_id
  #   time_offset
  #
  module Client
   private

    def call(method, options = { secure: false, encrypt: true }, payload = {})
      connection = (options[:secure] ? secure_connection : insecure_connection)
      response = connection.post do |request|
        request.url 'services/json/'
        request.headers['Content-Type'] = 'text/plain'
        request.params['method'] = method

        # Attach additional tokens and IDs as URL parameters if available
        request.params['auth_token'] = user_auth_token || partner_auth_token
        request.params['partner_id'] = partner_id if partner_id
        request.params['user_id']    = user_id    if user_id

        # Attach tokens and server time to JSON payload
        payload.merge!(syncTime: Time.now.to_i - time_offset) if time_offset
        if user_auth_token
          payload.merge!(userAuthToken: user_auth_token)
        elsif partner_auth_token
          payload.merge!(partnerAuthToken: partner_auth_token)
        end

        # Optionally encrypt the JSON request payload
        json = JSON.dump(payload)
        request.body = (options[:encrypt] ? cryptor.encrypt(json) : json)
      end

      # Check for API errors
      json = JSON.load(response.body)
      if json['stat'] != 'ok' || !json['result']
        raise APIError.new(json['message'], json['code'])
      end

      json['result']
    end

    def secure_connection
      @secure_connection ||= Faraday.new(url: "https://#{host}")
    end

    def insecure_connection
      @insecure_connection ||= Faraday.new(url: "http://#{host}")
    end

    def host
      'tuner.pandora.com'
    end
  end
end
