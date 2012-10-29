require 'tractis_api'

class AttestorSignaturesController < ApplicationController
  
  def create
    @signature = AttestorSignature.new params[:attestor_signature]
		
		if @signature.valid?
	      @signature.save
			  redirect_to attestor_signature_url(@signature.token)
    else
      flash[:error] = @signature.errors.map {|a,m| "#{m.capitalize}"}.uniq.join("<br/>\n")
      redirect_to attestor_url(@signature.proposal, :signature => params[:attestor_signature])
    end
  end
	
	
	#Se enseña la página donde está la declaración firmada
	def show
	  @signature = Signature.find_by_token params[:id]
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
			else
				flash[:error] = @signature.errors.map {|a,m| "#{m.capitalize}"}.uniq.join("<br/>\n")
			end
		else
			flash[:error] = "Este identificador de firma ya ha sido firmado"
		end
	end	
	
end