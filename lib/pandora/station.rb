require 'pandora/util/client'
require 'pandora/song'
require 'forwardable'

module Pandora
  class Station
    include Client
    extend Forwardable

    attr_reader :id, :name, :created_at, :url, :shared, :sharing_url,
                :quick_mix, :quick_mix_station_ids, :allow_rename,
                :allow_add_music, :allow_delete
    attr_reader :user
    attr_accessor :token

    [:quick_mix, :allow_rename, :allow_add_music, :allow_delete].each do |method|
      alias_method "#{method}?".to_sym, method
    end

    def_delegators :@user, *Client::ALL_STATE_ATTRIBUTES

    def initialize(user, data = nil)
      @user = user
      load_from_data(data) if data
    end

    def rename(new_name)
      # TODO: check allow_rename? force option?
      result = call 'station.renameStation', { secure: false, encrypt: true }, {
        stationToken: @token,
        stationName:  new_name
      }
      load_from_data(result)
    end

    def delete
      # TODO: check allow_delete? force option?
      call 'station.deleteStation', { secure: false, encrypt: true }, {
        stationToken: @token
      }
    end

    def next_songs(audio_formats = Song::DEFAULT_AUDIO_FORMATS)
      result = call 'station.getPlaylist', { secure: true, encrypt: true }, {
        stationToken:       @token,
        additionalAudioUrl: audio_formats.join(',')
      }

      result['items'].map do |song_data|
        Song.new(self, song_data, audio_formats)
      end
    end


   private

    def load_from_data(data)
      @id                    = data['stationId']
      @name                  = data['stationName']
      @token                 = data['stationToken']
      @created_at            = Time.at(data['dateCreated']['time'] / 1000.0)
      @url                   = data['stationDetailUrl']
      @shared                = data['isShared']
      @sharing_url           = data['stationSharingUrl']
      @quick_mix             = data['isQuickMix']
      @quick_mix_station_ids = data['quickMixStationIds']
      @allow_rename          = data['allowRename']
      @allow_add_music       = data['allowAddMusic']
      @allow_delete          = data['allowDelete']
    end
  end
end


# TODO: override inspect so cryptor doesn't ruin it
