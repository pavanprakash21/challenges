module Hackattic
  # Password Hashing
  class PasswordHashing
    require 'digest'
    require 'openssl'
    require 'base64'

    HMAC_DIGEST = 'SHA256'.freeze

    attr_reader :password, :salt, :rounds, :n_param,
                :p_param, :r_param, :buf_len

    def initialize(password:, salt:, pbkdf2:, scrypt:)
      p [password, salt, pbkdf2, scrypt]
      @password = password
      @salt     = salt
      @rounds   = pbkdf2[:rounds]
      @n_param  = scrypt[:N]
      @p_param  = scrypt[:p]
      @r_param  = scrypt[:r]
      @buf_len  = scrypt[:buflen]
    end

    def call
      {
        sha256: sha256_hash,
        hmac: hmac_hash,
        pbkdf2: pbkdf2_hash,
        scrypt: scrypt_hash
      }
    end

    private

    def sha256_hash
      Digest::SHA256.hexdigest password
    end

    def hmac_hash
      OpenSSL::HMAC.hexdigest(HMAC_DIGEST, salt_key, password)
    end

    def pbkdf2_hash
      length = OpenSSL::Digest::SHA256.new.digest_length
      hash = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password, salt_key, rounds, length)
      Base64.encode64(hash)
    end

    def scrypt_hash
      hash = OpenSSL::KDF.scrypt(
        password,
        salt: salt_key,
        N: 2**exponent,
        r: r_param,
        p: p_param,
        length: buf_len
      )
      Base64.encode64(hash)
    end

    def exponent
      (Math.log(n_param) / Math.log(2)).to_i
    end

    def salt_key
      @salt_key ||= Base64.decode64(salt)
    end
  end
end
