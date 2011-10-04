class MainController < ApplicationController

  def about_us; end
  
  def como_funciona; end
	
	
	# GET /main
  def index
    @ilp_proposals = IlpProposal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ilp_proposals }
    end
  end
end
