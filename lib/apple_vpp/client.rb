require 'rest_client'
require 'json'

module AppleVPP
  class Client

    attr_accessor :s_token

    def initialize(s_token)
      @s_token = s_token
      @url_service = UrlService.new
    end

    def associate_license_with_user(params = {})
      require_params [[:user_id, :client_user_id_str], [:adam_id, :license_id]], params

      body = {
        'userId'          => params[:user_id],
        'clientUserIdStr' => params[:client_user_id_str],
        'adamId'          => params[:adam_id],
        'licenseId'       => params[:license_id],
        'pricingParam'    => params[:pricing_param]
      }

      resp = request :associate_license_srv_url, body

      AppleSerializer.to_ruby [ resp['license'], resp['user'] ]
    end

    def disassociate_license_from_user(params = {})
      require_params :license_id, params

      body = {
        'licenseId' => params[:license_id]
      }

      resp = request :disassociate_license_srv_url, body

      AppleSerializer.to_ruby [ resp['license'], resp['user'] ]
    end

    def client_config(params = {})
      body = {
        'clientContext' => params[:client_context],
        'apnToken'      => params[:apn_token]
      }

      resp = request :client_config_srv_url, body

      AppleSerializer.to_ruby resp['clientContext']
    end

    def edit_user(params = {})
      require_params [[:user_id, :client_user_id_str]], params

      body = {
        'userId'          => params[:user_id],
        'clientUserIdStr' => params[:client_user_id_str],
        'email'           => params[:email]
      }

      resp = request :edit_user_srv_url, body

      AppleSerializer.to_ruby resp['user']
    end

    def get_licenses(params = {})
      licenses = []
      batch_token = nil

      begin

        body = {
          'batchToken'          => batch_token,
          'sinceModifiedToken'  => params[:since_modified_token],
          'adamId'              => params[:adam_id],
          'pricingParam'        => params[:pricing_param]
        }

        resp = request :get_licenses_srv_url, body

        licenses.concat( resp['licenses'] ) if resp['licenses']

        batch_token = resp['batchToken']

      end while batch_token

      AppleSerializer.to_ruby licenses
    end

    def get_user(params = {})
      require_params [[:user_id, :client_user_id_str]], params
     
      body = {
        'userId'          => params[:user_id], 
        'clientUserIdStr' => params[:client_user_id_str], 
        'itsIdHash'       => params[:its_id_hash]
      }

      resp = request :get_user_srv_url, body

      AppleSerializer.to_ruby resp['user']
    end

    def register_user(params = {})
      require_params :client_user_id_str, params

      body = {
        'clientUserIdStr' => params[:client_user_id_str],
        'email'           => params[:email]
      }

      resp = request :register_user_srv_url, body
    
      AppleSerializer.to_ruby resp['user']
    end

    def retire_user(params = {})
      require_params [[:user_id, :client_user_id_str]], params

      body = {
        'userId'          => params[:user_id],
        'clientUserIdStr' => params[:client_user_id_str]
      }

      resp = request :retire_user_srv_url, body

      AppleSerializer.to_ruby resp['user']
    end

    def get_users(params = {})
      users = []
      batch_token = nil

      begin

        body = {
          'batchToken'          => batch_token,
          'sinceModifiedToken'  => params[:since_modified_token],
          'includeRetired'      => params[:include_retired] ? 1 : nil
        }

        resp = request :get_users_srv_url, body

        users.concat( resp['users'] ) if resp['users']

        batch_token = resp['batchToken']

      end while batch_token

      AppleSerializer.to_ruby users
    end

    private
    
    # param_name_array is an array of required parameters. Include a sub-array of parameters for || requirement.

    def require_params param_name_array, params
      param_name_array = [param_name_array] unless param_name_array.kind_of? Array 

      param_name_array.each do |param_names|
        param_names = [param_names] unless param_names.kind_of?(Array)

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

    def request url_service_url, body
      @url_service.refresh unless @url_service.ready?

      url = @url_service.send( url_service_url )

      Request.submit url, @s_token, body
    end

  end
end
