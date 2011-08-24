class ProposalsController < ApplicationController
  # GET /proposals
  # GET /proposals.xml
  def index
    @proposals = Proposal.all
		@proposal = Proposal.first
		@provinces = Province.order("name")
		@signature = @proposal.signatures.new(params[:signature])

    share_texts(@proposals.first)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proposals }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.xml
  def show
    @proposal = Proposal.find(params[:id])
		@provinces = Province.order("name")
		@signature = @proposal.signatures.new(params[:signature])
		
    share_texts(@proposal)
		
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proposal }
    end
  end

end
