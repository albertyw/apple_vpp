require "spec_helper"

describe AppleVPP::Client do
  let(:s_token) { "asdf" }
  subject { AppleVPP::Client.new s_token }

  describe '#associate_license_with_user' do
    let(:params) { { user_id: 1, adam_id: 1 } }
    let(:response) { { "license" => {}, "user" => {} } }
    it "will have a deprecation warning" do
      expect(subject).to receive(:warn)
      expect(subject).to receive(:request).and_return(response)
      subject.associate_license_with_user params
    end
  end

  describe '#disassociate_license_from_user' do
    let(:params) { { license_id: 5 } }
    let(:response) { { "license" => {}, "user" => {} } }

    it "will have a deprecation warning" do
      expect(subject).to receive(:warn)
      expect(subject).to receive(:request).and_return(response)
      subject.disassociate_license_from_user params
    end
  end
end
