class EndorsmentSignaturesController < ApplicationController
  # GET /endorsment_signatures
  # GET /endorsment_signatures.xml
  def index
    @endorsment_signatures = EndorsmentSignature.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @endorsment_signatures }
    end
  end

  # GET /endorsment_signatures/1
  # GET /endorsment_signatures/1.xml
  def show
    @endorsment_signature = EndorsmentSignature.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @endorsment_signature }
    end
  end

  # GET /endorsment_signatures/new
  # GET /endorsment_signatures/new.xml
  def new
    @endorsment_signature = EndorsmentSignature.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @endorsment_signature }
    end
  end

  # GET /endorsment_signatures/1/edit
  def edit
    @endorsment_signature = EndorsmentSignature.find(params[:id])
  end

  # POST /endorsment_signatures
  # POST /endorsment_signatures.xml
  def create
    @endorsment_signature = EndorsmentSignature.new(params[:endorsment_signature])

    respond_to do |format|
      if @endorsment_signature.save
        format.html { redirect_to(@endorsment_signature, :notice => 'Endorsment signature was successfully created.') }
        format.xml  { render :xml => @endorsment_signature, :status => :created, :location => @endorsment_signature }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @endorsment_signature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /endorsment_signatures/1
  # PUT /endorsment_signatures/1.xml
  def update
    @endorsment_signature = EndorsmentSignature.find(params[:id])

    respond_to do |format|
      if @endorsment_signature.update_attributes(params[:endorsment_signature])
        format.html { redirect_to(@endorsment_signature, :notice => 'Endorsment signature was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @endorsment_signature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /endorsment_signatures/1
  # DELETE /endorsment_signatures/1.xml
  def destroy
    @endorsment_signature = EndorsmentSignature.find(params[:id])
    @endorsment_signature.destroy

    respond_to do |format|
      format.html { redirect_to(endorsment_signatures_url) }
      format.xml  { head :ok }
    end
  end
end
