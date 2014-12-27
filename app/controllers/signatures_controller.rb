require 'tractis_api'

class SignaturesController < ApplicationController
	
  def create
	  
		@signature = IlpSignature.new params[:ilp_signature]
		
	if @signature.valid?
	    @signature.save
		#Enviamos el nuevo registro a la lista de acumbamail
		client = HTTPClient.new
		target_url = "http://acumbamail.com/list/subscribe/url/call/12654/"
		url_query = ["token","qYGq4ZI7lKi3unQFYwG4"],["email_1", @signature.email], ["char_01", @signature.name], ["char_02", @signature.surname], ["integer_1", @signature.proposal_id]
		client.get(target_url,url_query)
		
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
		@signature = Signature.find params[:id]
		
		if not process_signature? @signature
			redirect_to signature_url(@signature.token)
		end
	end

	def social
		@signature = Signature.find_by_token params[:id]
		@proposal = @signature.proposal
		share_texts(@proposal, @signature)    
		render :layout => false
	end
end