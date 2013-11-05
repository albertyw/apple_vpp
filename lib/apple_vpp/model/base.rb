module AppleVPP
  module Model
    class Base

      def initialize(attributes = {})
        attributes.each do |attribute, value|
          self.send("#{attribute}=", value)
        end
      end

      def new_from_json(json)
        w_underscored_keys = Hash[ json.collect { |k, v| [k.underscore, v] } ]
        initialize w_underscored_keys
      end

    end
  end
end
