# coding: utf-8
require 'zip/zip'
class ApplicationController < ActionController::Base
  before_filter :authenticate
	protect_from_forgery
	include SessionsHelper
	  

	@provinces = Province.order("name")
	

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "asociacionmifirma" && password == "asociacionmifirma"
    end if Rails.env.staging?
  end

	def share_texts(proposal, user=nil)
    @share_title = "Ya he firmado la propuesta #{proposal.name}, ¡únete!"
		
		if proposal.class.name=="EndorsmentProposal"
		  @share_url = endorsment_proposal_url(proposal) 
		else
			@share_url = proposal_url(proposal)
		end
    
    @twitter_text = "Ya he firmado la propuesta #{proposal.name} #{@share_url}"
    @fb_text = @share_title
    logger.debug "@share_url -> #{@share_url}"
    logger.debug "@fb_text -> #{@fb_text}"
    unless user.nil?
      @email_subject = "#{@signature.name} ya ha firmado la propuesta de #{proposal.name}"
      @email_body = "Mifirma.com es una plataforma para desarrollar Iniciativas Legislativas Populares (ILP) a través de firma digital, cumpliendo todos los requisitos especificados en la vigente normativa de aplicación, para poder llevarlas de manera efectiva al Parlamento, y poder crear las leyes que los ciudadanos creemos justas y necesarias.\n#{@signature.name} ha firmado la propuesta de NOMBRE PROPUESTA (enlace), únete con tu firma para crear juntos las leyes que los ciudadanos nos merecemos.\n\nMifirma.com"
    end    
  end
	
	
  protected
	def get_zip_signatures (signatures)
	
		if !signatures.blank?
		  file_name = "signatures.zip"
		  t = Tempfile.new("my-temp-filename-#{Time.now.to_i}","#{Rails.root}/tmp")
		  Zip::ZipOutputStream.open(t.path) do |z|
			signatures.each do |signature|
			  title = signature.tractis_signature_file_name
			  z.put_next_entry(title)
						file = signature.tractis_signature.to_file
			  z.print file.read
						file.close
        end
      end
      t.close
      send_file t.path, :type => 'application/zip',
                             :disposition => 'attachment',
                             :filename => file_name

    end	
  end	
	
	# Process the signature and returns false if errors
	def process_signature? (signature)
	
		logger.debug 'Estamos procesando la firma'	
		
		if not signature.signed?

			@signature.xmlSigned = Base64.decode64(params[:xmlSigned2])
			
			validation = @signature.validate_signature
			
			if not validation.isValid?
				flash[:error] = "La firma no es válida. Compruebe que el certificado no esté caducado o revocado"
				return false
			end
			
			if validation.psisNIF != signature.dni
				flash[:error] = "El DNI introducido en el formulario no coincide con el DNI del Certificado"
				return false			
			end

			@signature.state = 1
			
			if @signature.valid?
				@proposal = @signature.proposal
				@signature.get_afirma_signature		
				share_texts(@proposal, @signature)
				signature.notifier
				return true
			else
				flash[:error] = @signature.errors.map {|a,m| "#{m.capitalize}"}.uniq.join("<br/>\n")
				return false
			end
		else
			flash[:error] = "Este identificador de firma ya ha sido firmado"
			return false
		end
	end
end
