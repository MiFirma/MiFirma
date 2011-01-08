require "spec_helper"

describe Signature do
  
  it "should generate a token after creation" do
    signature = Signature.create
    signature.token.should_not be_nil
  end
  
  it "should have pending state after creation" do
    signature = Signature.create
    signature.state.should == 0
  end
  
  it "should have a signature url" do
    signature = Signature.create
    signature.return_url.should == "http://www.mifirma.com/signatures/#{signature.token}"
  end

end