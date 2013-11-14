module AppleVPP
  module Error

    def self.create_error_class code
      class_name = "Code#{code}"
      begin
        Module.const_get(class_name)
        self.const_set class_name, ( Class.new StandardError )
      rescue NameError
      end
    end

  end
end