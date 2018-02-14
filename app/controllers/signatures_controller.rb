require 'tractis_api'

class SignaturesController < ApplicationController
	
  def create
	  
		@signature = IlpSignature.new params[:ilp_signature]
		
		if @signature.valid?
			@signature.save
			#Enviamos el nuevo registro a la lista de acumbamail
			#client = HTTPClient.new
			#target_url = "http://acumbamail.com/list/subscribe/url/call/12654/"
			#url_query = ["token","qYGq4ZI7lKi3unQFYwG4"],["email_1", @signature.email], ["char_01", @signature.name], ["char_02", @signature.surname], ["integer_1", @signature.proposal_id]
			#client.get(target_url,url_query)
			respond_to do |format|
				format.html {
						redirect_to signature_url(@signature.token)
					}
				format.xml  { render :xml => @signature.token }
			end
		else
				respond_to do |format|
					format.html {
							flash[:error] = @signature.errors.map {|a,m| "#{m.capitalize}"}.uniq.join("<br/>\n")
							redirect_to proposal_url(@signature.proposal, :signature => params[:ilp_signature])
						}
					format.xml  { render :xml => @signature.errors }
				end		
		end
  end
  
  #Se obtiene el xml del aval y se envía a firmar
  def show
		@signature = Signature.find_by_token params[:id]
		@xmlOCEenc = ::TractisApi.signature_request_ilp_fnmt @signature           
		respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @xmlOCEenc }
    end		
  end
	
  #Se obtiene el resultado
	def share
		@signature = Signature.find_by_token params[:id]

		if @signature.nil?
			respond_to do |format|
				format.html {	redirect_to root_path }
				format.xml  { render :xml => "No existe token" and return }
			end
		end
		
		if not process_signature? @signature
			respond_to do |format|
				format.html {	redirect_to signature_url(@signature.token) }
				format.xml  { render :xml => flash[:error] }
			end
		else
			respond_to do |format|
				format.html {	render }
				format.xml  { render :xml => "OK" }
			end
		end
	end

	def social
		@signature = Signature.find_by_token params[:id]
		@proposal = @signature.proposal
		share_texts(@proposal, @signature)    
		render :layout => false
	end
end