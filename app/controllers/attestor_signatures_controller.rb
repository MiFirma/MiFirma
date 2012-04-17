require 'tractis_api'

class AttestorSignaturesController < ApplicationController
  
  def create
    @signature = AttestorSignature.new params[:attestor_signature]

    if @signature.valid?
		  begin
				tractis_signature_request = ::TractisApi.signature_request_attestor @signature
				@signature.update_attribute :tractis_contract_location, tractis_signature_request[:location]
			rescue StandardError => e 
				::Rails.logger.debug "AttestorSignaturesController - Rescue"
				flash[:error] = "Error accediendo a la plataforma de firma electrónica"
				redirect_to attestor_url(@signature.proposal, :signature => params[:attestor_signature])
			  return
			end
			::Rails.logger.debug "Redireccionando a tractis"
      redirect_to @signature.tractis_contract_location
    else
		  ::Rails.logger.debug @signature.errors
      flash[:error] = @signature.errors.map {|a,m| "#{m.capitalize}"}.uniq.join("<br/>\n")
      redirect_to attestor_url(@signature.proposal, :signature => params[:attestor_signature])
    end
  end
end