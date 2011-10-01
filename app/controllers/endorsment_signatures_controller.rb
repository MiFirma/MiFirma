require 'tractis_api'

class EndorsmentSignaturesController < ApplicationController
  
  def create
    @signature = EndorsmentSignature.new params[:endorsment_signature]

    if @signature.valid?
		  begin
				::TractisApi.signature_request_endorsment @signature
			rescue StandardError => e 
				flash[:error] = e.message
				redirect_to endorsment_proposal_url(@signature.endorsment_proposal, :endorsment_signature => params[:endorsment_signature])
			  return
			end
      redirect_to @signature.tractis_contract_location
    else
      flash[:error] = @signature.errors.map {|a,m| "#{m.capitalize}"}.uniq.join("<br/>\n")
      redirect_to endorsment_proposal_url(@signature.endorsment_proposal, :endorsment_signature => params[:endorsment_signature])
    end
  end
end
