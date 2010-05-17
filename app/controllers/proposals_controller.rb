class ProposalsController < ApplicationController
  def index
    @proposals = Proposal.all
  end
  
  def show
    @proposal = Proposal.find params[:id]
  end
end
