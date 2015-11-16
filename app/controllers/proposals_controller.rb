class ProposalsController < ApplicationController
	#caches_page :index
  before_filter :authenticate, :only => [:edit, :update, :signatures]
	before_filter :correct_user, :only => [:edit, :update, :signatures]
	
  # GET /proposals
  # GET /proposals.xml
  def index
    @proposals = IlpProposal.on_signature_time

    respond_to do |format|
      format.xml  { render :xml => @proposals }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.xml
  def show
    @proposal = IlpProposal.find(params[:id])
		@provinces = Province.order("name").find(@proposal.subtype_provinces.split(",").map { |s| s.to_i }) if @proposal.subtype_provinces
		@signature = @proposal.signatures.new(params[:signature])
		@title = @proposal.problem
		@reasons = ReasonFeedback.all
		@feedback_signature = FeedbackSignature.new
		@feedback_signature.proposal = @proposal
		@feedback_signature.signature = @signature
		
    share_texts(@proposal)
		
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proposal }
    end
  end

	
  # GET /proposals/1/signatures
	def signatures
	  proposal = Proposal.find(params[:id])
		get_zip_signatures(proposal.signatures.signed)
	end	
	
	
	def update
    # Los filtros ya nos crean el objeto @proposal
    if @proposal.update_attributes(params[:ilp_proposal])
      flash[:success] = "Cambios en la propuesta realizados con éxito."
      redirect_to @user
    else
      render 'edit'
    end
  end	
	
	private

    def authenticate
      deny_access unless signed_in?
    end
		
		def correct_user
			@proposal = Proposal.find(params[:id])
			@user = @proposal.user
			redirect_to(root_path) unless current_user?(@user)
		end	
	
end
