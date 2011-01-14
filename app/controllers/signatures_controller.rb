class SignaturesController < ApplicationController
  
  def create
    @signature = Signature.create params[:signature]
    tractis_signature_request = TractisApi.signature_request @signature
    redirect_to tractis_signature_request[:location]
  end
  
end
