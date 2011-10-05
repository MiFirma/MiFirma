class MainController < ApplicationController

  def about_us; end
  
  def como_funciona; end
	
	
	# GET /main
  def index
    @ilp_proposals = IlpProposal.on_signature_time
		@endorsment_proposals = EndorsmentProposal.on_signature_time

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
