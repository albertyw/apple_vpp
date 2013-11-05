module AppleVPP
  module Model
    class User < Base

      attr_accessor :user_id, 
                    :email, 
                    :client_user_id_str, 
                    :status, 
                    :its_id_hash,
                    :invite_url,
                    :invite_code,
                    :licenses


      def initialize(params = {})
        @licenses = []

        super(params)
      end
      
    end
  end
end
