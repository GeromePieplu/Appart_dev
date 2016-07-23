class AppartementsController < ApplicationController
  # GET /appartements
  # GET /appartements.xml
  # Type_location : meublé, meublé avec forfait électrique , non meublé
  def type_loc    
     @type_location = ['Meublé','MeubléElec','nonMeublé']
  end  
  
  def etat    
     @etat = ['en_location','indisponible','vendu']
  end  

  def index
    @appartements = Appartement.find(:all , :order => "nom" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @appartements }
    end
  end

  # GET /appartements/1
  # GET /appartements/1.xml
  def show
    @appartement = Appartement.find(params[:id])
    @proprietaire = Proprietaire.find(@appartement.proprietaire_id)
    @gerant = Proprietaire.find(@appartement.gerant_id)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @appartement }
    end
  end

  # GET /appartements/new
  # GET /appartements/new.xml
  def new
    @appartement = Appartement.new
    @type_location = type_loc
    @etat = etat
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @appartement }
    end
  end

  # GET /appartements/1/edit
  def edit
    @appartement = Appartement.find(params[:id])
    @proprietaire = Proprietaire.find(@appartement.proprietaire_id)
    @gerant = Proprietaire.find(@appartement.gerant_id)
    @type_location = type_loc
    @etat = etat
  end

  # POST /appartements
  # POST /appartements.xml
  def create
    @appartement = Appartement.new(params[:appartement])

    respond_to do |format|
      if @appartement.save
        flash[:notice] = 'Appartement was successfully created.'
        format.html { redirect_to(@appartement) }
        format.xml  { render :xml => @appartement, :status => :created, :location => @appartement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @appartement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /appartements/1
  # PUT /appartements/1.xml
  def update
    @appartement = Appartement.find(params[:id])
  #Commentaire
    respond_to do |format|
      if @appartement.update_attributes(params[:appartement])
        flash[:notice] = 'Appartement was successfully updated.'
        format.html { redirect_to(@appartement) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @appartement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /appartements/1
  # DELETE /appartements/1.xml
  def destroy
    @appartement = Appartement.find(params[:id])
    @appartement.destroy

    respond_to do |format|
      format.html { redirect_to(appartements_url) }
      format.xml  { head :ok }
    end
  end
  

  
def showOccupation
  @appartement = Appartement.find(params[:id])
  @anneeCourrante = Date.today.year
  @anneeSuivante = @anneeCourrante + 1
  if (@anneeCourrante % 2 == 0) #annee paire
    @tabAnneeCour = @appartement.occupationAnneePaire
    @tabAnneeSuiv = @appartement.occupationAnneeImpaire
  else
    @tabAnneeCour = @appartement.occupationAnneeImpaire
    @tabAnneeSuiv = @appartement.occupationAnneePaire
  end  
  render(:layout => false)
end  









end  

