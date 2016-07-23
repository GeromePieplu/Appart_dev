class DepensesController < ApplicationController
  # Use a different layout
  layout 'appartements'
  # GET /depenses
  # GET /depenses.xml
  require 'date'
  

  
  def index
    redirect_to(:controller=>"factures")
  end

  # GET /depenses/1
  # GET /depenses/1.xml
  def show
    @depense = Depense.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @depense }
    end
  end

  # GET /depenses/new
  # GET /depenses/new.xml
  def new
    @facture = Facture.find(params[:id])
    @depense = Depense.new
    @depense.facture_id = @facture.id
    if @facture.immeuble_id.nil? then
      @appartements = getAppart
    else
      @appartements = Appartement.find(:all, :conditions =>{:immeuble_id =>@facture.immeuble_id})
    end    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @depense }
    end
  end


  # POST /depenses
  # POST /depenses.xml
  def create
    @depense = Depense.new(params[:depense])
    @facture = Facture.find(@depense.facture_id)
    retourParam = params[:choix]
    if not @depense.montant_reparti.nil? then
      @depense.repartition = @depense.montant_reparti / @facture.montant
    else
        @depense.montant_reparti = @facture.montant * @depense.repartition
    end
      
    respond_to do |format|
      if @depense.save
        flash[:notice] = 'Depense was successfully created.'
        format.html { redirect_to(:controller=>"factures", :action=>"show", :id=>@facture.id) }
        format.xml  { render :xml => @depense, :status => :created, :location => @depense }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @depense.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /depenses/1
  # DELETE /depenses/1.xml
  def destroy
    @depense = Depense.find(params[:id])
    @depense.destroy

    respond_to do |format|
      format.html { redirect_to(depenses_url) }
      format.xml  { head :ok }
    end
  end
end
