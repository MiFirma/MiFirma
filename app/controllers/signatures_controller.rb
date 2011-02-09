class SignaturesController < ApplicationController
  
  def create
    @signature = Signature.create params[:signature]
    if @signature.valid?
      tractis_signature_request = TractisApi.signature_request @signature
      @signature.update_attribute :tractis_contract_location, tractis_signature_request[:location]
      if @signature.tractis_contract_location
        redirect_to @signature.tractis_contract_location
      else
        flash[:error] = "Error de comunicación con Tractis, por favor vuelva a intentarlo."        
      end
    else
      flash[:error] = "Error al crear la firma, email no válido."
      redirect_to proposal_url(@signature.proposal)
    end
  end
  
  def show
    @signature = Signature.find_by_token params[:id]
    @proposal = @signature.proposal
  end
  
end
