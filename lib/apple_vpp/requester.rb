require 'rest-client'
require 'json'

module AppleVPP
  class Requester

    def initialize( s_token )
      @s_token      = s_token
      @url_service  = UrlService.new
    end

    def submit( url_service_url, body = {}, disable_refresh = false )
      @url_service.refresh( self, nil, true ) unless @url_service.ready? || disable_refresh

      url = @url_service.send( url_service_url )

      body['sToken'] = @s_token
      body.delete_if { |_k, v| v.nil? }

      resp = RestClient.post url, body, content_type: :json
      json = JSON.parse(resp)

      check_for_error(json)

      json
    end

    private

    def check_for_error( json )
      if json['status'] == -1
        raise StandardError, "error #{json['errorCode']}: #{json['errorMessage']}"
      end
    end
    
  end
end

