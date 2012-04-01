# coding: utf-8
require 'zip/zip'
class ApplicationController < ActionController::Base
  protect_from_forgery
	include SessionsHelper
	
	@provinces = Province.order("name")
	

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
      t = Tempfile.new("my-temp-filename-#{Time.now.to_i}")
      Zip::ZipOutputStream.open(t.path) do |z|
        signatures.each do |signature|
          title = signature.tractis_signature_file_name
          z.put_next_entry(title)
					file = signature.tractis_signature.to_file(:original)
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
end
