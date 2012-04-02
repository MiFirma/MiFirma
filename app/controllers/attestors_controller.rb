class AttestorsController < ApplicationController
  before_filter :authenticate, :only => [:list, :signatures]
	before_filter :correct_user, :only => [:list, :signatures]

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

  # GET /attestors/1/list.csv
  def list
    proposal = IlpProposal.find(params[:id])
		@attestors = proposal.attestors_signatures
		
    respond_to do |format|
      format.csv  { render :layout => false }
    end
  end

	# GET /attestors/1/signatures
	def signatures
	  proposal = IlpProposal.find(params[:id])
		@attestors = proposal.attestors_signatures.order("id")
		
		get_zip_signatures(@attestors)
	end	
		
	private

    def authenticate
      deny_access unless signed_in?
    end
		
		def correct_user
			@proposal = IlpProposal.find(params[:id])
			@user = @proposal.user
			redirect_to(root_path) unless current_user?(@user)
		end	
end