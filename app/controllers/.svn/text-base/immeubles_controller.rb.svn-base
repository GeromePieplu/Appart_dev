class ImmeublesController < ApplicationController
  # Use a different layout
  layout 'appartements'
  # GET /immeubles
  # GET /Immeuble.xml
  def index
    @immeubles = Immeuble.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @immeubles }
    end
  end

  # GET /immeubles/1
  # GET /immeubles/1.xml
  def show
    @immeubles = Immeuble.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @immeubles }
    end
  end

  # GET /immeubles/new
  # GET /immeubles/new.xml
  def new
    @immeubles = Immeuble.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @immeubles }
    end
  end

  # GET /immeubles/1/edit
  def edit
    @immeubles = Immeuble.find(params[:id])
  end

  # POST /immeubles
  # POST /Immeuble.xml
  def create
    @immeubles = Immeuble.new(params[:immeuble])

    respond_to do |format|
      if @immeubles.save
        flash[:notice] = 'Immeubles was successfully created.'
        format.html { redirect_to(@immeubles) }
        format.xml  { render :xml => @immeubles, :status => :created, :location => @immeubles }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @immeubles.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /immeubles/1
  # PUT /immeubles/1.xml
  def update
    @immeubles = Immeuble.find(params[:id])

    respond_to do |format|
      if @immeubles.update_attributes(params[:immeuble])
        flash[:notice] = 'Immeubles was successfully updated.'
        format.html { redirect_to(@immeubles) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @immeubles.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /immeubles/1
  # DELETE /immeubles/1.xml
  def destroy
    @immeubles = Immeuble.find(params[:id])
    @immeubles.destroy

    respond_to do |format|
      format.html { redirect_to(immeubles_url) }
      format.xml  { head :ok }
    end
  end
end
