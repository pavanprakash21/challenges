module Hackattic
  # Tales of SSL
  class TalesOfSsl
    require 'base64'
    require 'openssl'

    require_relative '../../utils/country_list'
    require_relative '../../utils/exceptions/not_found_error'

    attr_reader :private_key, :domain, :serial_number, :country

    def initialize(private_key:, required_data:)
      @private_key   = private_key
      @domain        = required_data[:domain]
      @serial_number = required_data[:serial_number].to_i(16)
      @country       = required_data[:country]
    end

    def call
      puts [private_key, domain, serial_number, country]
      { certificate: solution }
    end

    private

    def solution
      Base64.encode64(signed_cert)
    end

    def signed_cert
      @signed_cert ||= certificate.sign(key, OpenSSL::Digest::SHA1.new).to_der
    end

    def certificate
      @certificate ||= OpenSSL::X509::Certificate.new.tap do |cert|
        cert.serial     = serial_number
        cert.version    = 0
        cert.subject    = subject
        cert.issuer     = subject
        cert.not_before = Time.now
        cert.not_after  = Time.now + 365 * 24 * 60 * 60 # Valid for one year
        cert.public_key = public_key
      end
    end

    def key
      @key ||= OpenSSL::PKey::RSA.new(decoded_private_key)
    end

    def decoded_private_key
      Base64.decode64(private_key)
    end

    def public_key
      key.public_key
    end

    def country_code
      COUNTRY_CODES[country]
    end

    def subject
      raise_not_found_error if country_code.nil?

      @subject ||= OpenSSL::X509::Name.new(
        [
          ['C', country_code, OpenSSL::ASN1::PRINTABLESTRING],
          ['CN', domain, OpenSSL::ASN1::UTF8STRING]
        ]
      )
    end

    def raise_not_found_error
      raise NotFoundError, "Country code not found for #{country}"
    end
  end
end
