require 'tractis_api'

class SignaturesController < ApplicationController
	
  def create
	  
		@signature = IlpSignature.new params[:ilp_signature]
		
		if @signature.valid?
	      @signature.save
			  redirect_to signature_url(@signature.token)
    else
      flash[:error] = @signature.errors.map {|a,m| "#{m.capitalize}"}.uniq.join("<br/>\n")
      redirect_to proposal_url(@signature.proposal, :signature => params[:ilp_signature])
    end
	end
  
		#Se obtiene el xml del aval y se envía a firmar
	def show
	  @signature = Signature.find_by_token params[:id]
		@xmlOCEenc = Base64.encode64(::TractisApi.signature_request_ilp_fnmt @signature)
	end
	
	#Se obtiene el resultado
	def share
	  @signature = IlpSignature.find params[:id]
		
		if not @signature.signed?
			@signature.xmlSigned = Base64.decode64(params[:xmlSigned2])
			logger.debug 'Estamos dentro del metodo share en Signatures'
			@proposal = @signature.proposal
			@signature.check_and_get_afirma_signature
			if @signature.valid?
				share_texts(@proposal, @signature)    
				Notifier.ilp_signed(@signature).deliver
			else
				flash[:error] = @signature.errors.map {|a,m| "#{m.capitalize}"}.uniq.join("<br/>\n")
			end
	
		else
			flash[:error] = "Este identificador de firma ya ha sido firmado"
		end
	end
	
	def social
    @signature = Signature.find_by_token params[:id]
    @proposal = @signature.proposal
    share_texts(@proposal, @signature)    
    render :layout => false
  end
end