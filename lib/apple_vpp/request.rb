require 'rest-client'
require 'json'

module AppleVPP
  class Request

    def self.submit( url, s_token = nil, body = {} )
      body['sToken'] = s_token
      body.delete_if { |_k, v| v.nil? }
require 'awesome_print'
ap body
      begin

        resp = RestClient.post url, body, content_type: :json

      rescue RestClient::ExceptionWithResponse => e

        unless e.response.code == 503
          raise e
        end

        raise AppleVPP::Error::ServiceUnavailable.new(e.response.raw_headers['Retry-After'])

      end

      json = JSON.parse(resp)

      if json['status'] == -1
        raise (eval "AppleVPP::Error::Code#{json['errorNumber']}"), json['errorMessage']
      end

      json
    end

  end
end

