require 'spec_helper'

describe AppleVPP::Error do
  describe '.get_error' do
    it 'will return the proper error class' do
      error = AppleVPP::Error.get_error 9600
      expect(error).to eq AppleVPP::Error::Code9600
    end
  end
end
