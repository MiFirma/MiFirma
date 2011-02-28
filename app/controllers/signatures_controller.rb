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
      flash[:error] = @signature.errors.map {|a,m| "#{m.capitalize}"}.uniq.join("<br/>\n")
      redirect_to proposal_url(@signature.proposal, :signature => params[:signature])
    end
  end
  
  def show
    @signature = Signature.find_by_token params[:id]
    @proposal = @signature.proposal
    @signature.check_tractis_signature!
    share_texts(@proposal, @signature)    
  end
  
  def share
    render :layout => false
  end
  
end
