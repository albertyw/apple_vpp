module AppleVPP
  class UrlService

    SERVICE_URL = 'https://vpp.itunes.apple.com/WebObjects/MZFinance.woa/wa/'

    attr_reader :associate_license_srv_url,
                :client_config_srv_url,
                :disassociate_license_srv_url,
                :edit_user_srv_url,
                :get_licenses_srv_url,
                :get_user_srv_url,
                :get_users_srv_url,
                :invitation_email_url,
                :register_user_srv_url,
                :retire_user_srv_url,
                :vpp_website_url,
                :errors

    def initialize
      @errors = {}
      @ready  = false
    end

    def refresh
      url = "#{SERVICE_URL}VPPServiceConfigSrv"
      resp = Request.submit url

      @associate_license_srv_url    = resp['associateLicenseSrvUrl']
      @client_config_srv_url        = resp['clientConfigSrvUrl']
      @disassociate_license_srv_url = resp['disassociateLicenseSrvUrl']
      @edit_user_srv_url            = resp['editUserSrvUrl']
      @get_licenses_srv_url         = resp['getLicensesSrvUrl']
      @get_user_srv_url             = resp['getUserSrvUrl']
      @get_users_srv_url            = resp['getUsersSrvUrl']
      @invitation_email_url         = resp['invitationEmailUrl']
      @register_user_srv_url        = resp['registerUserSrvUrl']
      @retire_user_srv_url          = resp['retireUserSrvUrl']
      @vpp_website_url              = resp['vppWebsiteUrl']

      resp['errorCodes'].each do |i|
        @errors[ i['errorNumber'] ] = i['errorMessage']
      end

      @errors.each do | number, _message| 
        AppleVPP::Error.create_error_class( number )
      end

      @ready = true
    end

    def ready?
      @ready
    end

  end
end
