class EndorsmentProposalsController < ApplicationController
	#caches_page :index
  before_filter :authenticate, :only => [:edit, :update]
	before_filter :correct_user, :only => [:edit, :update]
	
	
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
		@signature = @endorsment_proposal.signatures.new(params[:signature])
		@provinces = Province.order("name")
		@title = @endorsment_proposal.name
		
		share_texts(@endorsment_proposal)
    
		respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @endorsment_proposal }
    end
  end
	
	def update
    # Los filtros ya nos crean el objeto @proposal
    if @proposal.update_attributes(params[:endorsment_proposal])
      flash[:success] = "Cambios en la propuesta realizados con éxito."
      redirect_to @user
    else
      render 'edit'
    end
  end	
	
	# GET /endorsment_proposals/show_signatures_by_province/1
  # GET /endorsment_proposals/show_signatures_by_province/1.xml
	def show_signatures_by_province
		@endorsment_proposal = EndorsmentProposal.find(params[:id])

		respond_to do |format|
      format.html # show_signatures_by_province.html.erb
      format.xml  { render :xml => @endorsment_proposal }
    end
	end
	
	
	private

	def authenticate
		deny_access unless signed_in?
	end
	
	def correct_user
		@proposal = EndorsmentProposal.find(params[:id])
		@user = @proposal.user
		redirect_to(root_path) unless current_user?(@user)
	end	
end
