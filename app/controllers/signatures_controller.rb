class SignaturesController < ApplicationController
  
  def create
    @signature = Signature.create params[:signature]
    if @signature.valid?
      tractis_signature_request = TractisApi.signature_request @signature
      redirect_to tractis_signature_request[:location]
    else
      raise "Error al crear la firma"
    end
  end
  
end
