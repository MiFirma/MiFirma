class EndorsmentProposalsController < ApplicationController
  # GET /endorsment_proposals
  # GET /endorsment_proposals.xml
  def index
    @endorsment_proposals = EndorsmentProposal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @endorsment_proposals }
    end
  end

  # GET /endorsment_proposals/1
  # GET /endorsment_proposals/1.xml
  def show
    @endorsment_proposal = EndorsmentProposal.find(params[:id])
		@signature = @endorsment_proposal.endorsment_signatures.new(params[:endorsment_signature])
		@provinces = Province.order("name")
		
		share_texts(@endorsment_proposal)
    
		respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @endorsment_proposal }
    end
  end

end
