class SignaturesController < ApplicationController
  
  def create
    @signature = Signature.create params[:signature]
    if @signature.valid?
      tractis_signature_request = TractisApi.signature_request @signature
      redirect_to tractis_signature_request[:location]
    else
      flash[:error] = "Error al crear la firma, email no válido."
      redirect_to proposal_url(@signature.proposal)
    end
  end
  
end
