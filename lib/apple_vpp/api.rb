require 'rest_client'
require 'json'

module AppleVPP
  class API

    attr_accessor :s_token

    def initialize(s_token)
      @s_token = s_token
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

      refresh_url_service
      resp = Request.submit( UrlService.instance.associate_license_srv_url, @s_token, body )

      license = Model::License.new_from_json resp['license']
      user    = Model::User.new_from_json    resp['user']

      [license, user]
    end

    def disassociate_license_from_user(params = {})
      require_params :license_id, params

      body = {
        'licenseId' => params[:license_id]
      }

      refresh_url_service
      resp = Request.submit UrlService.instance.disassociate_license_srv_url, @s_token, body

      license = Model::License.new_from_json resp['license']
      user    = Model::User.new_from_json    resp['user']

      [license, user]
    end

    def client_config(params = {})
      body = {
        'clientContext' => params[:client_context],
        'apnToken'      => params[:apn_token]
      }

      refresh_url_service
      resp = Request.submit UrlService.instance.client_config_srv_url, @s_token, body

      resp['clientContext']
    end

    def edit_user(params = {})
      require_params [[:user_id, :client_user_id_str]], params

      body = {
        'userId'          => params[:user_id],
        'clientUserIdStr' => params[:client_user_id_str],
        'email'           => params[:email]
      }

      refresh_url_service
      resp = Request.submit UrlService.instance.edit_user_srv_url, @s_token, body

      Model::User.new_from_json resp['user']
    end

    def licenses(params = {})
      licenses = []
      batch_token = nil

      refresh_url_service

      begin

        body = {
          'batchToken'          => batch_token,
          'sinceModifiedToken'  => params[:since_modified_token],
          'adamId'              => params[:adam_id],
          'pricingParam'        => params[:pricing_param]
        }

        resp = Request.submit( UrlService.instance.get_licenses_srv_url, @s_token, body )

        if resp['licenses']
          resp['licenses'].each do |i|
            licenses << Model::License.new_from_json( i )
          end
        end

        batch_token = resp['batchToken']

      end while batch_token

      licenses
    end

    def find_user(params = {})
      require_params [[:user_id, :client_user_id_str]], params
     
      refresh_url_service

      body = {
        'userId'          => params[:user_id], 
        'clientUserIdStr' => params[:client_user_id_str], 
        'itsIdHash'       => params[:its_id_hash]
      }

      refresh_url_service
      resp = Request.submit( UrlService.instance.get_user_srv_url, @s_token, body )

      build_user_and_licenses( resp['user'] )
    end

    def register_user(params = {})
      require_params :client_user_id_str, params

      body = {
        'clientUserIdStr' => params[:client_user_id_str],
        'email'           => params[:email]
      }

      refresh_url_service
      resp = Request.submit( UrlService.instance.register_user_srv_url, @s_token, body )
    
      Model::User.new resp['user']
    end

    def retire_user(params = {})
      require_params [[:user_id, :client_user_id_str]], params

      body = {
        'userId'          => params[:user_id],
        'clientUserIdStr' => params[:client_user_id_str]
      }

      refresh_url_service
      resp = Request.submit( UrlService.instance.retire_user_srv_url, @s_token, body)

      build_user_and_licenses( resp['user'] )
    end

    def users(params = {})
      users = []
      batch_token = nil

      refresh_url_service

      begin

        body = {
          'batchToken'          => batch_token,
          'sinceModifiedToken'  => params[:since_modified_token],
          'includeRetired'      => params[:include_retired] ? 1 : nil
        }

        resp = Request.submit( UrlService.instance.get_users_srv_url, @s_token, body )

        if resp['users']
          resp['users'].each do |i|
            users << Model::User.new_from_json( i )
          end
        end

        batch_token = resp['batchToken']

      end while batch_token

      users
    end

    private
    
    # param_name_array is an array of required parameters. Include a sub-array of parameters for || requirement.

    def require_params param_name_array, params
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

    def refresh_url_service
      UrlService.instance.refresh unless UrlService.instance.ready?
    end

    def build_user_and_licenses(user_json)
      just_user_json = user_json.clone
      just_user_json.delete('licenses')

      user = Model::User.new_from_json( just_user_json )

      user_json['licenses'].each do |i|
        user.licenses << Model::License.new_from_json( i )
      end
    end

  end
end
