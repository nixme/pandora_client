require 'pandora/client'
require 'forwardable'

module Pandora
  class User
    include Client
    extend Forwardable

    attr_reader :partner, :username, :password
    attr_reader :user_auth_token, :user_id

    def_delegators :@partner, :cryptor, :partner_id, :partner_auth_token,
                              :time_offset

    def initialize(partner, username, password)
      @partner, @username, @password = partner, username, password
      login
    end

    def stations
      call('user.getStationList')['items'].map do |station_data|
        station = Station.new(self)
        station.load_data(station_data)
        station
      end
    end


   private

    def login
      result = call 'auth.userLogin', { secure: true, encrypt: true }, {
        loginType: 'user',
        username: username,
        password: password
      }

      @user_auth_token = result['userAuthToken']
      @user_id = result['userId']

      result
    end
  end
end
