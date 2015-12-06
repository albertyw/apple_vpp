require "rest_client"
require "json"

module AppleVPP
  class Client
    attr_accessor :s_token

    def initialize(s_token)
      @s_token = s_token
      @url_service = UrlService.new
    end

    def associate_license_with_user(params = {})
      warn "This request is deprecated.  Use manage_licenses_by_adam_id instead"
      require_params [[:user_id, :client_user_id_str], [:adam_id, :license_id]], params

      body = {
        "userId"          => params[:user_id],
        "clientUserIdStr" => params[:client_user_id_str],
        "adamId"          => params[:adam_id],
        "licenseId"       => params[:license_id],
        "pricingParam"    => params[:pricing_param],
      }

      resp = request :associate_license_srv_url, body

      AppleSerializer.to_ruby [resp["license"], resp["user"]]
    end

    def disassociate_license_from_user(params = {})
      warn "This request is deprecated.  Use manage_licenses_by_adam_id instead"
      require_params :license_id, params

      body = {
        "licenseId" => params[:license_id],
      }

      resp = request :disassociate_license_srv_url, body

      AppleSerializer.to_ruby [resp["license"], resp["user"]]
    end

    def client_config(params = {})
      body = {
        "clientContext" => params[:client_context],
        "apnToken"      => params[:apn_token],
      }

      resp = request :client_config_srv_url, body
      resp.delete("status")

      AppleSerializer.to_ruby resp
    end

    def edit_user(params = {})
      require_params [[:user_id, :client_user_id_str]], params

      body = {
        "userId"          => params[:user_id],
        "clientUserIdStr" => params[:client_user_id_str],
        "email"           => params[:email],
      }

      resp = request :edit_user_srv_url, body

      AppleSerializer.to_ruby resp["user"]
    end

    def get_assets(params = {})
      body = {
        "includeLicenseCounts" => params[:include_license_counts],
      }

      resp = request :get_vpp_assets_srv_url, body
      return [] if resp == { "status" => 0 }

      AppleSerializer.to_ruby resp["assets"]
    end

    def get_licenses(params = {})
      licenses = []
      batch_token = nil
      since_modified_token = nil

      begin

        body = {
          "batchToken"          => batch_token,
          "sinceModifiedToken"  => params[:since_modified_token],
          "adamId"              => params[:adam_id],
          "pricingParam"        => params[:pricing_param],
        }

        resp = request :get_licenses_srv_url, body

        licenses.concat(resp["licenses"]) if resp["licenses"]

        batch_token = resp["batchToken"]
        since_modified_token = resp["sinceModifiedToken"]

      end while batch_token

      {
        licenses:             AppleSerializer.to_ruby(licenses),
        since_modified_token: since_modified_token,
      }
    end

    def get_user(params = {})
      require_params [[:user_id, :client_user_id_str]], params

      body = {
        "userId"          => params[:user_id],
        "clientUserIdStr" => params[:client_user_id_str],
        "itsIdHash"       => params[:its_id_hash],
      }

      resp = request :get_user_srv_url, body

      AppleSerializer.to_ruby resp["user"]
    end

    def manage_licenses_by_adam_id(params = {})
      require_params [:adam_id_str, :pricing_param], params

      unless params.has_key?(:associate_client_user_id_strs) ^
          params.has_key?(:associate_serial_numbers) ^
          params.has_key?(:disassociate_client_user_id_strs) ^
          params.has_key?(:disassociate_license_id_strs)
        raise ArgumentError, "One and only one of these parameters may be provided: associate_client_user_id_strs, associate_serial_numbers, disassociate_client_user_id_strs, disassociate_license_id_strs."
      end

      body = {
        "adamIdStr"                    => params[:adam_id_str],
        "associateClientUserIdStrs"    => params[:associate_client_user_id_strs],
        "associateSerialNumbers"       => params[:associate_serial_numbers],
        "disassociateClientUserIdStrs" => params[:disassociate_client_user_id_strs],
        "disassociateLicenseIdStrs"    => params[:disassociate_license_id_strs],
        "pricingParam"                 => params[:pricing_param],
        "notifyDisassociation"         => params[:notify_disassociation],
      }

      resp = request :manage_vpp_licenses_by_adam_id_srv_url, body

      ret = AppleSerializer.to_ruby resp
      ret.delete(:status)

      ret
    end

    def register_user(params = {})
      require_params :client_user_id_str, params

      body = {
        "clientUserIdStr" => params[:client_user_id_str],
        "email"           => params[:email],
      }

      resp = request :register_user_srv_url, body

      AppleSerializer.to_ruby resp["user"]
    end

    def retire_user(params = {})
      require_params [[:user_id, :client_user_id_str]], params

      body = {
        "userId"          => params[:user_id],
        "clientUserIdStr" => params[:client_user_id_str],
      }

      resp = request :retire_user_srv_url, body

      AppleSerializer.to_ruby resp["user"]
    end

    def get_users(params = {})
      users = []
      batch_token = nil
      since_modified_token = nil

      begin

        body = {
          "batchToken"          => batch_token,
          "sinceModifiedToken"  => params[:since_modified_token],
          "includeRetired"      => params[:include_retired] ? 1 : nil,
        }

        resp = request :get_users_srv_url, body

        users.concat(resp["users"]) if resp["users"]

        batch_token = resp["batchToken"]
        since_modified_token = resp["sinceModifiedToken"]

      end while batch_token

      {
        users:                AppleSerializer.to_ruby(users),
        since_modified_token: since_modified_token,
      }
    end

    private

    # param_name_array is an array of required parameters. Include a sub-array of parameters for || requirement.

    def require_params(param_name_array, params)
      param_name_array = [param_name_array] unless param_name_array.is_a? Array

      param_name_array.each do |param_names|
        param_names = [param_names] unless param_names.is_a?(Array)

        param_found = false
        param_names.each do |param_name|
          if params[param_name]
            param_found = true
            break
          end
        end

        unless param_found
          raise ArgumentError, "#{param_names.join(' or ')} must be provided"
        end
      end
    end

    def request(url_service_url, body)
      @url_service.refresh unless @url_service.ready?

      url = @url_service.send(url_service_url)

      Request.submit url, @s_token, body
    end
  end
end
