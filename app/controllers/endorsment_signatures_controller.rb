require 'tractis_api'

class EndorsmentSignaturesController < ApplicationController
  
  def create
    @signature = EndorsmentSignature.new params[:endorsment_signature]

		debugger
		
		if @signature.valid?
			if params[:Certificado] == 'OTROS'
				tractis_signature_request = ::TractisApi.signature_request_endorsment @signature
				@signature.update_attribute :tractis_contract_location, tractis_signature_request[:location]
				if @signature.tractis_contract_location
					redirect_to @signature.tractis_contract_location
				else
					flash[:error] = "Error de comunicación con Tractis, por favor vuelva a intentarlo."
					logger.debug 'Error de comunicación con Tractis'
					@signature.destroy
					redirect_to endorsment_proposal_url(@signature.proposal, :signature => params[:endorsment_signature])
				end			
			else

			end
    else
      flash[:error] = @signature.errors.map {|a,m| "#{m.capitalize}"}.uniq.join("<br/>\n")
      redirect_to endorsment_proposal_url(@signature.proposal, :signature => params[:endorsment_signature])
    end
		
  end
end
