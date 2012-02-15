class AttestorsController < ApplicationController


  # GET /attestors/1
  # GET /attestors/1.xml
  def show
    @proposal = IlpProposal.find(params[:id])
		@provinces = Province.order("name").where("only_circunscription = ?", false)
		@signature = @proposal.attestors_signatures.new(params[:signature])
		@title = @proposal.problem
		
    share_texts(@proposal)
		
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proposal }
    end
  end

end