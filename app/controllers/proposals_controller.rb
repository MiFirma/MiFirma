class ProposalsController < ApplicationController
  def index
    @proposals = Proposal.all
    share_texts(@proposals.first)
  end
  
  def show
    @proposal = Proposal.find params[:id]
    share_texts(@proposal)
  end
  
end
