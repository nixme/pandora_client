require 'pandora/util/client'
require 'pandora/station'
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

    def reauthenticate
      @partner.reauthenticate
      login
    end

    def stations
      call('user.getStationList')['stations'].map do |station_data|
        Station.new(self, station_data)
      end
    end

    def marshal_dump
      [@partner, @username, @password, @user_auth_token, @user_id]
    end

    def marshal_load(objects)
      @partner, @username, @password, @user_auth_token, @user_id = objects
    end


   private

    def login
      @user_auth_token = @user_id = nil

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
