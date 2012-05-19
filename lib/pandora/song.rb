require 'pandora/util/client'
require 'forwardable'
require 'nokogiri'

module Pandora
  class Song
    include Client
    extend Forwardable

    ALL_AUDIO_FORMATS =
      ['HTTP_40_AAC_MONO', 'HTTP_64_AAC', 'HTTP_64_AACPLUS',
       'HTTP_24_AACPLUS_ADTS', 'HTTP_32_AACPLUS_ADTS', 'HTTP_64_AACPLUS_ADTS',
       'HTTP_128_MP3', 'HTTP_192_MP3', 'HTTP_32_WMA']
    DEFAULT_AUDIO_FORMATS =
      ['HTTP_32_AACPLUS_ADTS', 'HTTP_64_AACPLUS_ADTS', 'HTTP_192_MP3']

    attr_reader :title, :token, :artist, :album, :album_art_url, :rating, :gain,
                :allow_feedback, :url, :album_url, :artist_url,
                :amazon_album_asin, :amazon_album_digital_asin,
                :amazon_song_digital_asin, :amazon_album_url, :itunes_song_url,
                :song_explorer_url, :album_explorer_url, :artist_explorer_url,
                :audio_url, :audio_urls

    def_delegators :@station, *Client::ALL_STATE_ATTRIBUTES

    def initialize(station, data, audio_formats)
      @station = station
      load_from_data(data, audio_formats)
    end

    def id
      load_explorer_data unless @id
      @id
    end


   private

    def load_from_data(data, audio_formats)
      @title = data['songName']
      @token = data['trackToken']
      @artist = data['artistName']
      @album = data['albumName']
      @album_art_url = data['albumArtUrl']
      @rating = data['songRating']
      @gain = data['trackGain']
      @allow_feedback = data['allowFeedback']
      @url = data['songDetailUrl']
      @album_url = data['albumDetailUrl']
      @artist_url = data['artistDetailUrl']

      @amazon_album_asin = data['amazonAlbumAsin']
      @amazon_album_digital_asin = data['amazonAlbumDigitalAsin']
      @amazon_song_digital_asin = data['amazonSongDigitalAsin']
      @amazon_album_url = data['amazonAlbumUrl']
      @itunes_song_url = data['itunesSongUrl']

      @song_explorer_url = data['songExplorerUrl']
      @album_explorer_url = data['albumExplorerUrl']
      @artist_explorer_url = data['artistDetailUrl']

      @audio_url = data['audioUrl']
      @audio_urls =
        if (additional_audio_urls = data['additionalAudioUrl'])
          Hash[audio_formats.zip(additional_audio_urls)]
        else
          {}
        end
    end

    # Unfortunately the Tuner API track JSON doesn't include the musicId, a
    # track identifier that's constant among different user sessions. However,
    # we can fetch it via the Song's Explorer XML URL.
    def load_explorer_data
      document = Nokogiri::XML(Faraday.get(@song_explorer_url).body)
      @id = document.search('songExplorer').first['musicId']
    end
  end
end
