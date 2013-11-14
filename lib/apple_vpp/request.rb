require 'rest-client'
require 'json'

module AppleVPP
  class Request

    def self.submit( url, s_token = nil, body = {} )
      body['sToken'] = s_token
      body.delete_if { |_k, v| v.nil? }
      
      resp = RestClient.post url, body, content_type: :json
      json = JSON.parse(resp)

      if json['status'] == -1
        raise (eval "AppleVPP::Error::Code#{json['errorNumber']}"), json['errorMessage'] 
      end

      json
    end

  end
end

