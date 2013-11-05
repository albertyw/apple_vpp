require 'rest-client'
require 'json'

module AppleVPP
  class Request

    def self.submit( url, s_token = nil, body = {} )
      body['sToken'] = s_token
      body.delete_if { |_k, v| v.nil? }

      resp = RestClient.post url, body, content_type: :json
      json = JSON.parse(resp)

      check_for_error(json)

      json
    end

    private

    def self.check_for_error(json)
      if json['status'] == -1
        raise StandardError, "error #{json['errorCode']}: #{json['errorMessage']}"
      end
    end
    
  end
end

