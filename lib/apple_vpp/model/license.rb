module AppleVPP
  module Model
    class License < Base

      attr_accessor :license_id, 
                    :adam_id,
                    :product_type_id,
                    :pricing_param,
                    :product_type_name,
                    :is_irrevocable,
                    :user_id,
                    :client_user_id_str,
                    :its_id_hash,
                    :status
                    
    end
  end
end
