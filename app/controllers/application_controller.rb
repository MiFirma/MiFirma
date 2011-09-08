# coding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
	
	@provinces = Province.order("name")
	

	def share_texts(proposal, user=nil)
    @share_title = "Ya he firmado la propuesta #{proposal.name}, ¡únete!"
    @share_url = proposal_url(proposal)
    
    @twitter_text = "Ya he firmado la propuesta #{proposal.name} #{@share_url}"
    @fb_text = @share_title
    logger.debug "@share_url -> #{@share_url}"
    logger.debug "@fb_text -> #{@fb_text}"
    unless user.nil?
      @email_subject = "#{@signature.name} ya ha firmado la propuesta de #{proposal.name}"
      @email_body = "Mifirma.com es una plataforma para desarrollar Iniciativas Legislativas Populares (ILP) a través de firma digital, cumpliendo todos los requisitos especificados en la vigente normativa de aplicación, para poder llevarlas de manera efectiva al Parlamento, y poder crear las leyes que los ciudadanos creemos justas y necesarias.\n#{@signature.name} ha firmado la propuesta de NOMBRE PROPUESTA (enlace), únete con tu firma para crear juntos las leyes que los ciudadanos nos merecemos.\n\nMifirma.com"
    end    
  end
end
