require 'test_helper'

class SignatureTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "signatures of the same proposal must not have same dni" do
    signature = Signature.new(:email => signatures(:javier).email,
															:state => 1,
															:token => 2345,
															:tractis_contract_location => 6543,
															:name => 'Juanito',
															:dni => signatures(:javier).email,
															:surname => 'Gómez',
															:proposal => proposals(:one))
		assert !signature.save
  end
end
