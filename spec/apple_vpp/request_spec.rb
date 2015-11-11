require "spec_helper"

describe AppleVPP::Request do
  describe ".submit" do
    it "will check for errors" do
      data = JSON.dump(status: 0)
      expect(RestClient).to receive(:post).and_return data
      expect(AppleVPP::Request).to receive(:check_for_errors)
      AppleVPP::Request.submit("url")
    end
  end

  describe ".check_for_errors" do
    it "will do nothing if the status is fine" do
      data = { status: 0 }
      AppleVPP::Request.check_for_errors data
    end
    it "will raise an error if the request has an error" do
      data = { "status" => -1, "errorNumber" => 9604, "errorMessage" => "asdf" }
      expect { AppleVPP::Request.check_for_errors data }.to raise_error(AppleVPP::Error::Code9604)
    end
    it "will raise an error for specific associations" do
      data = { "associations" => [{ "errorMessage" => "Registered user not found", "errorCode" => 9609, "clientUserIdStr" => "1234" }], "status" => -1 }
      expect { AppleVPP::Request.check_for_errors data }.to raise_error(AppleVPP::Error::Code9609)
    end
  end
end
