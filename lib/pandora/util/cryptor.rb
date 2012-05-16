require 'crypt/blowfish'

module Pandora

  # Blowfish encryptor/decryptor for the Pandora Tuner API
  #
  # Ciphertext is round-tripped to and from ASCII-encoded hexadecimal
  # characters.
  #
  # Keys must be provided. Available at
  # http://pan-do-ra-api.wikia.com/wiki/Json/5/partners
  #
  class Cryptor
    def initialize(encryption_key, decryption_key)
      @encryptor = Crypt::Blowfish.new(encryption_key)
      @decryptor = Crypt::Blowfish.new(decryption_key)
    end

    def encrypt(str)
      str.force_encoding(Encoding::BINARY).
        scan(/.{1,8}/).map do |block|               # Operate on 8 char chunks
        block = pad(block, 8) if block.length < 8   # Pad to 8 chars if under
        @encryptor.encrypt_block(block).            # Encrypt the data
          unpack('H*').first                        # Convert to ASCII hex
      end.join('')
    end

    def decrypt(str)
      str.force_encoding(Encoding::BINARY).
        scan(/.{1,16}/).map do |block|              # Operate on 16 char chunks
        block = pad([block].pack('H*'), 8)          # Convert ASCII hex to raw data
        @decryptor.decrypt_block(block)             # Decrypt the data
      end.join('').
        sub(/^(.*?)[[:cntrl:]]*$/, '\1')            # Strip trailing junk
    end

    # Override inspect so it doesn't include internal Blowfish P-array and
    # S-boxes from the instance variables.
    def inspect
      to_s
    end


   private

    def pad(str, length)
      str + ("\0" * [length - str.length, 0].max)
    end
  end
end
