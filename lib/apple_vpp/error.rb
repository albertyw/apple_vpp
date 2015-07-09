require 'time'

module AppleVPP
  class Error < ::StandardError

    codes = [ 9600, 9601, 9602, 9603, 9604, 9605, 9606, 9607, 9608, 9609,
              9610, 9611, 9612, 9613, 9614, 9615, 9616, 9617, 9618, 9619,
              9620, 9621, 9622, 9623, 9625, 9626 ]

    codes.each do |code|
      self.const_set "Code#{code}", ( Class.new AppleVPP::Error )
    end

    class ServiceUnavailable
      attr_accessor :retry_after

      def initialize retry_after
        @retry_after = retry_after
      end

      def retry_in_seconds
        if @retry_after == @retry_after.to_i.to_s
          @retry_after
        else
          Time.parse(@retry_after) - Time.now
        end
      end

    end

  end
end
