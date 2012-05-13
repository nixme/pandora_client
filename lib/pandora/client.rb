require 'crypt/blowfish'
require 'json' unless defined?(JSON)

module Pandora
  class Client
    HOST = 'tuner.pandora.com'
    VERSION  = '5'

    def initialize(options = {})
      @partner_options = options.fetch(:partner)
      @partner_username = options.fetch(:username)
      @partner_password = options.fetch(:password)
      @partner_device = options.fetch(:device)
      @encryption_key = options.fetch(:encryption_key)
      @decryption_key = options.fetch(:decryption_key)

      @cryptor = Cryptor.new(@encryption_key, @decryption_key)
      @secure_connection = Faraday.new(url: "https://#{HOST}")
      @insecure_connection = Faraday.new(url: "http://#{HOST}")
    end

    def login(username, password)
      partner_login unless @partner_auth_token

      result = call 'auth.userLogin', { secure: true, encrypt: true }, {
        loginType: 'user',
        username: username,
        password: password
      }

      @user_auth_token = result['userAuthToken']
      @user_id = result['userId']

      result
    end

    def stations
      result = call('user.getStationList')['items'].map do |station_data|
        Station.new(self, station_data)   # TODO: implement
      end
    end


   private

    def partner_login
      result = call 'auth.partnerLogin', { secure: true, encrypt: false }, {
        username: @partner_username,
        password: @partner_password,
        deviceModel: @partner_device,
        version: VERSION
      }

      @partner_id = result['partnerId']
      @partner_auth_token = result['partnerAuthToken']
      server_time = @cryptor.decrypt(result['syncTime'])[4..-1].to_i
      @time_offset = Time.now.to_i - server_time
    end

    def call(method, options = { secure: false, encrypt: true }, payload = {})
      connection = (options[:secure] ? @secure_connection : @insecure_connection)
      response = connection.post do |request|
        request.url 'services/json/'
        request.headers['Content-Type'] = 'text/plain'
        request.params['method'] = method

        # Attach additional tokens and IDs as URL parameters if available
        request.params['auth_token'] = @user_auth_token || @partner_auth_token
        request.params['partner_id'] = @partner_id if @partner_id
        request.params['user_id']    = @user_id    if @user_id

        # Attach tokens and server time to JSON payload
        payload.merge!(syncTime: Time.now.to_i - @time_offset) if @time_offset
        if @user_auth_token
          payload.merge!(userAuthToken: @user_auth_token)
        elsif @partner_auth_token
          payload.merge!(partnerAuthToken: @partner_auth_token)
        end

        # Optionally encrypt the JSON request payload
        json = JSON.dump(payload)
        request.body = (options[:encrypt] ? @cryptor.encrypt(json) : json)
      end

      # Check for API errors
      json = JSON.load(response.body)
      if json['stat'] != 'ok' || !json['result']
        raise APIError.new(json['message'], json['code'])
      end

      json['result']
    end
  end
end
