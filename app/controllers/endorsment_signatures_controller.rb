﻿require 'tractis_api'
require "base64"

class EndorsmentSignaturesController < ApplicationController
  
  def create
    @signature = EndorsmentSignature.new params[:endorsment_signature]
		
		if @signature.valid?
	      @signature.save
			  redirect_to endorsment_signature_url(@signature.token)
    else
      flash[:error] = @signature.errors.map {|a,m| "#{m.capitalize}"}.uniq.join("<br/>\n")
      redirect_to endorsment_proposal_url(@signature.proposal, :signature => params[:endorsment_signature])
    end
  end
	
	#Se obtiene el xml del aval y se envía a firmar
	def show
	  @signature = Signature.find_by_token params[:id]
		@xmlOCEenc = Base64.encode64(::TractisApi.signature_request_endorsment_fnmt @signature)
	end
	
	#Se obtiene el resultado
	def share
	  @signature = Signature.find params[:id]
		
		if not @signature.signed?
			@signature.xmlSigned = Base64.decode64(params[:xmlSigned2])
			logger.debug 'Estamos dentro del metodo share en Signatures'
			@proposal = @signature.proposal
			@signature.check_and_get_afirma_signature
			if @signature.valid?
				share_texts(@proposal, @signature)    
				Notifier.endorsment_signed(@signature).deliver
			else
				flash[:error] = @signature.errors.map {|a,m| "#{m.capitalize}"}.uniq.join("<br/>\n")
			end
	
		else
			flash[:error] = "Este identificador de firma ya ha sido firmado"
		end
	end
end
