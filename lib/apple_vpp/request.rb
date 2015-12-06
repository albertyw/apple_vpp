require "rest-client"
require "json"

module AppleVPP
  class Request
    IGNORED_ERROR_CODES = [
      "9602", # No license to disassociate
      "9616", # License already assigned
    ]

    def self.submit(url, s_token = nil, body = {})
      body["sToken"] = s_token
      body.delete_if { |_k, v| v.nil? }
      begin

        resp = RestClient.post url, body, content_type: :json

      rescue RestClient::ExceptionWithResponse => e

        unless e.response.code == 503
          raise e
        end

        raise AppleVPP::Error::ServiceUnavailable.new(e.response.raw_headers["Retry-After"])

      end

      json = JSON.parse(resp)

      check_for_errors json

      json
    end

    def self.check_for_errors(json)
      if json["status"] == -1
        if json.include? "errorNumber"
          raise_error json["errorNumber"], json["errorMessage"]
        end

        associations = []
        if json.include? "associations"
          associations += json["associations"]
        end
        if json.include? "disassociations"
          associations += json["disassociations"]
        end
        associations.each do |association|
          if association.include? "errorCode"
            if IGNORED_ERROR_CODES.include? association["errorCode"].to_s
              next
            end
            raise_error association["errorCode"], association["errorMessage"]
          end
        end
      end
    end

    def self.raise_error(error_code, error_message)
      raise AppleVPP::Error.get_error(error_code), error_message
    end
  end
end
