module AppleVPP
  module Error

    codes = [ 9600, 9601, 9602, 9603, 9604, 9605, 9606, 9607, 9608, 9609, 
              9610, 9611, 9612, 9613, 9614, 9615, 9616, 9617, 9618, 9619, 
              9620, 9621, 9622, 9623 ]

    codes.each do |code|
      self.const_set "Code#{code}", ( Class.new StandardError )
    end

  end
end