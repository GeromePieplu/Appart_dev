class ProprietairesController < ApplicationController
  # Use a different layout
  layout 'appartements'
  # GET /proprietaires
  # GET /proprietaires.xml
  def index
    @proprietaires = Proprietaire.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proprietaires }
    end
  end

  # GET /proprietaires/1
  # GET /proprietaires/1.xml
  def show
    @proprietaire = Proprietaire.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proprietaire }
    end
  end

  # GET /proprietaires/new
  # GET /proprietaires/new.xml
  def new
    @proprietaire = Proprietaire.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @proprietaire }
    end
  end

  # GET /proprietaires/1/edit
  def edit
    @proprietaire = Proprietaire.find(params[:id])
  end

  # POST /proprietaires
  # POST /proprietaires.xml
  def create
    @proprietaire = Proprietaire.new(params[:proprietaire])

    respond_to do |format|
      if @proprietaire.save
        flash[:notice] = 'Proprietaire was successfully created.'
        format.html { redirect_to(@proprietaire) }
        format.xml  { render :xml => @proprietaire, :status => :created, :location => @proprietaire }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @proprietaire.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /proprietaires/1
  # PUT /proprietaires/1.xml
  def update
    @proprietaire = Proprietaire.find(params[:id])

    respond_to do |format|
      if @proprietaire.update_attributes(params[:proprietaire])
        flash[:notice] = 'Proprietaire was successfully updated.'
        format.html { redirect_to(@proprietaire) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @proprietaire.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /proprietaires/1
  # DELETE /proprietaires/1.xml
  def destroy
    @proprietaire = Proprietaire.find(params[:id])
    @proprietaire.destroy

    respond_to do |format|
      format.html { redirect_to(proprietaires_url) }
      format.xml  { head :ok }
    end
  end
end
