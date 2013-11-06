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

      resp = associate_vpp_license_with_vpp_user( params[:user_id],
                                                  params[:client_user_id_str],
                                                  params[:adam_id],
                                                  params[:license_id],
                                                  params[:pricing_param] )

      license = Model::License.new_from_json resp['license']
      user    = Model::User.new_from_json    resp['user']

      [license, user]
    end

    def disassociate_license_from_user(params = {})
      require_params :license_id, params

      resp = disassociate_vpp_license_from_vpp_user( params[:license_id] )

      license = Model::License.new_from_json resp['license']
      user    = Model::User.new_from_json    resp['user']

      [license, user]
    end

    def client_config(params = {})
      resp = vpp_client_config(params[:client_context], params[:apn_token])

      resp['clientContext']
    end

    def edit_user(params = {})
      require_params [[:user_id, :client_user_id_str]], params

      resp = edit_vpp_user(params[:user_id], params[:client_user_id_str], params[:email])

      Model::User.new_from_json resp['user']
    end

    def licenses(params = {})
      licenses = []
      batch_token = nil

      begin

        resp = get_vpp_licenses( batch_token, nil, params[:adam_id], params[:pricing_param] )

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
     
      resp = get_vpp_user(params[:user_id], params[:client_user_id_str], params[:its_id_hash])

      build_user_and_licenses( resp['user'] )
    end

    def register_user(params = {})
      require_params :client_user_id_str, params

      resp = register_vpp_user( params[:client_user_id_str], params[:email] )
    
      Model::User.new resp['user']
    end

    def retire_user(params = {})
      require_params [[:user_id, :client_user_id_str]], params

      resp = retire_vpp_user( params[:user_id], params[:client_user_id_str] )

      build_user_and_licenses( resp['user'] )
    end

    def users(params = {})
      users = []
      batch_token = nil

      begin

        resp = get_vpp_users( batch_token, nil, params[:include_retired] )

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

    # 
    # Service Calls 
    #

    def associate_vpp_license_with_vpp_user( user_id, client_user_id_str, adam_id, license_id, pricing_param )
      refresh_url_service

      body = {
        'userId'          => user_id,
        'clientUserIdStr' => client_user_id_str,
        'adamId'          => adam_id,
        'licenseId'       => license_id,
        'pricingParam'    => pricing_param
      }

      Request.submit( UrlService.instance.associate_license_srv_url, @s_token, body )
    end

    def disassociate_vpp_license_from_vpp_user( license_id )
      refresh_url_service

      body = {
        'licenseId' => license_id
      }

      Request.submit UrlService.instance.disassociate_license_srv_url, @s_token, body
    end

    def edit_vpp_user(user_id , client_user_id_str, email)
      refresh_url_service

      body = {
        'userId' => user_id,
        'clientUserIdStr' => client_user_id_str,
        'email' => email
      }

      Request.submit UrlService.instance.edit_user_srv_url, @s_token, body
    end

    def get_vpp_licenses(batch_token, since_modified_token, adam_id, pricing_param)
      refresh_url_service

      body = {
        'batchToken'          => batch_token,
        'sinceModifiedToken'  => since_modified_token,
        'adamId'              => adam_id,
        'pricingParam'        => pricing_param
      }

      Request.submit( UrlService.instance.get_licenses_srv_url, @s_token, body )
    end

    def get_vpp_user(user_id, client_user_id_str, its_id_hash)
      refresh_url_service

      body = {
        'userId'          => user_id, 
        'clientUserIdStr' => client_user_id_str, 
        'itsIdHash'       => its_id_hash 
      }

      Request.submit( UrlService.instance.get_user_srv_url, @s_token, body )
    end

    def get_vpp_users(batch_token, since_modified_token, include_retired)
      refresh_url_service

      body = {
        'batchToken'          => batch_token,
        'sinceModifiedToken'  => since_modified_token
      }

      body['includeRetired'] = 1 if include_retired == true

      Request.submit( UrlService.instance.get_users_srv_url, @s_token, body )
    end

    def register_vpp_user(client_user_id_str, email)
      refresh_url_service

      body = {
        'clientUserIdStr' => client_user_id_str,
        'email'           => email
      }

      Request.submit( UrlService.instance.register_user_srv_url, @s_token, body )
    end

    def retire_vpp_user(user_id, client_user_id_str)
      refresh_url_service

      body = {
        'userId'          => user_id,
        'clientUserIdStr' => client_user_id_str
      }

      Request.submit( UrlService.instance.retire_user_srv_url, @s_token, body)
    end

    def vpp_client_config(client_context, apn_token)
      refresh_url_service

      body = {
        'clientContext' => client_context,
        'apnToken'      => apn_token
      }

      Request.submit UrlService.instance.client_config_srv_url, @s_token, body
    end

  end
end
