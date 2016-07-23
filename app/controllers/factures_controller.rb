class FacturesController < ApplicationController
    # Use a different layout
  layout 'appartements'
  # GET /factures
  # GET /factures.xml
  require 'date'
  
  def typeDepense    
    @typeDepense = ['toutes','Eau','Electricité','Internet','Gaz','Impots','Assurance','Entretien','Travaux','charge_Copro','carburant','intérêts','assuranceEmprunt']
  end
 

  
  def index
    majTypeDepense
    @factures = Facture.find(:all, :order=>"id DESC")
    if @current_user.login == 'admin' or @current_user.login == 'pieplu' then
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @factures }
        format.csv {render :action => "index.csv" , :layout => false}
      end
    else
      respond_to do |format|
        format.html { render :text => "L'accés à cette page n'est pas autorisé"}           
      end      
    end
  end

  # GET /factures/1
  # GET /factures/1.xml
  def show
    @facture = Facture.find(params[:id])
    @depenses = Depense.find(:all,  :conditions=>{:facture_id=>params[:id]}) 
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @depense }
    end
  end  
  
 # GET /factures/new
  # GET /factures/new.xml
  def new
    @facture = Facture.new
    @typeDepense = typeDepense
    @emetteurs = Facture.find(:all, :select=>"Distinct emetteur", :order=>"emetteur") 
    @soustypes = Facture.find(:all, :select=>"Distinct soustype", :order=>"soustype") 
    @immeubles = Immeuble.find(:all) 
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @facture }
    end
  end  


 # POST /factures
  # POST /factures.xml
  def create
    @emetteurs = Facture.find(:all, :select=>"Distinct emetteur", :order=>"emetteur") 
    @soustypes = Facture.find(:all, :select=>"Distinct soustype", :order=>"soustype")  
    @typeDepense = typeDepense
    @facture = Facture.new(params[:facture])
    retourParam = params[:choix]
    if @facture.emetteur == "" then 
      @facture.emetteur = retourParam["choixEmetteur"]
    end
    if @facture.soustype == "" then 
      @facture.soustype = retourParam["choixSoustype"]
    end

    respond_to do |format|
      if @facture.save
        flash[:notice] = 'Depense was successfully created.'
        format.html { redirect_to(@facture) }
        format.xml  { render :xml => @facture, :status => :created, :location => @facture }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @facture.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /factures/1/edit
  def edit
    @typeDepense = typeDepense
    @soustypes = Facture.find(:all, :select=>"Distinct soustype", :order=>"soustype") 
    @immeubles = Immeuble.find(:all) 
    @facture = Facture.find(params[:id])
  end
 
  # PUT /depenses/1
  # PUT /depenses/1.xml
  def update
    @facture = Facture.find(params[:id])
    @soustypes = Facture.find(:all, :select=>"Distinct soustype", :order=>"soustype")  
    @typeDepense = typeDepense
    retourParam = params[:choix] 
    parametre = params[:facture]
    if not retourParam["choixSoustype"] == "" then 
      parametre["soustype"] = retourParam["choixSoustype"]
    end

    respond_to do |format|
      if @facture.update_attributes(params[:facture])
        flash[:notice] = 'La facture à été modifié avec succés.'
        format.html { redirect_to(@facture) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @facture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /depenses/1
  # DELETE /depenses/1.xml
  def destroy
    @facture = Facture.find(params[:id])
    @depenses = Depense.find(:all, :conditions=>["facture_id = ?", @facture.id])
    @depenses.each do |depense|
      depense.destroy
    end
    @facture.destroy

    respond_to do |format|
      format.html { redirect_to(factures_url) }
      format.xml  { head :ok }
    end
  end  

  def choixFactures
    @facture = Facture.new
    @typeDepense = typeDepense
    @immeubles = Immeuble.find(:all)      
    respond_to do |format|
      format.html # index.html.erb
    end
  end
    
  def factureSelection
   @choix = params[:choix]
   @choixPeriode = params[:periode]
   @typeFacture = params[:type_facture]
   @choixSortie = params[:formatSortie]
   immeub = params[:immeuble]
   @immeuble = immeub[:immeuble]
   tousIm = params[:tousIm]
   tous = tousIm[:tous]
   if @choixPeriode == "Période" then
     @date_debut = Date.new( year=@choix["date_debut(1i)"].to_i, mon=@choix["date_debut(2i)"].to_i, mday=@choix["date_debut(3i)"].to_i)
     @date_fin = Date.new( year=@choix["date_fin(1i)"].to_i, mon=@choix["date_fin(2i)"].to_i, mday=@choix["date_fin(3i)"].to_i)
   elsif @choixPeriode == "annuelle" then  
     @date_annee = Date.new( year=@choix["date_debut(1i)"].to_i, mon=@choix["date_debut(2i)"].to_i, mday=@choix["date_debut(3i)"].to_i)
     @date_debut = Date.new( year=@date_annee.year, mon = 1, mday=1)
     @date_fin = Date.new( year=@date_annee.year, mon = 12, mday=31)
   elsif @choixPeriode == "année courante" then
     @date_annee = Date.today
     @date_debut = Date.new( year=@date_annee.year, mon = 1, mday=1)
     @date_fin = Date.new( year=@date_annee.year, mon = 12, mday=31)  
   elsif @choixPeriode == "toutes" then
     @date_debut = Date.new( year=2000, mon = 1, mday=1)
     @date_fin = Date.today          
   end
        
   if @typeFacture == "toutes" and @immeuble == "" and tous == "non" then
     @factures = Facture.find(:all,:order=>"id DESC",:conditions =>{:date=>@date_debut..@date_fin})
   elsif @typeFacture == "toutes" and @immeuble != ""  then
     @factures = Facture.find(:all,:order=>"id DESC",:conditions =>{:date=>@date_debut..@date_fin, :immeuble_id => @immeuble})
   elsif @typeFacture == "toutes" and @immeuble == "" and tous == "oui" then
     @factures = Facture.find(:all,:order=>"id DESC",:conditions =>{:date=>@date_debut..@date_fin, :immeuble_id => nil})
   elsif @typeFacture != "toutes" and @immeuble == "" and tous == "non" then
     @factures = Facture.find(:all,:order=>"id DESC",:conditions =>{:date=>@date_debut..@date_fin, :typeDepense => @typeFacture})
   elsif @typeFacture != "toutes" and @immeuble == "" and tous == "oui" then
     @factures = Facture.find(:all,:order=>"id DESC",:conditions =>{:date=>@date_debut..@date_fin, :typeDepense => @typeFacture, :immeuble_id => nil})
   elsif @typeFacture != "toutes" and @immeuble != ""  then 
     @factures = Facture.find(:all,:order=>"id DESC",:conditions =>{:date=>@date_debut..@date_fin, :typeDepense => @typeFacture,:immeuble_id => @immeuble})
   end  
   
   if @choixSortie == "excel" then
     respond_to do |format|
     format.csv {render :action => "index.csv" , :layout => false}
     end
   else  
     respond_to do |format|
         format.html {render :action => "index" , :layout =>'bilan' }
      end
    end
  end
 
 
   def choixDepenses
    @depense = Depense.new
    @typeDepense = typeDepense
    if @current_user.login == 'admin' then
      @appart = Appartement.find(:all)
    else
       @appart = getAppart
    end    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
    
  def depenseSelection
   @choix = params[:choix]
   @choixPeriode = params[:periode]
   @depense = params[:depense]
   @choixSortie = params[:formatSortie]
   @appt = Appartement.find(@depense["appartement_id"])
   if @choixPeriode == "Période" then
     @date_debut = Date.new( year=@choix["date_debut(1i)"].to_i, mon=@choix["date_debut(2i)"].to_i, mday=@choix["date_debut(3i)"].to_i)
     @date_fin = Date.new( year=@choix["date_fin(1i)"].to_i, mon=@choix["date_fin(2i)"].to_i, mday=@choix["date_fin(3i)"].to_i)
   elsif @choixPeriode == "annuelle" then  
     @date_annee = Date.new( year=@choix["date_debut(1i)"].to_i, mon=@choix["date_debut(2i)"].to_i, mday=@choix["date_debut(3i)"].to_i)
     @date_debut = Date.new( year=@date_annee.year, mon = 1, mday=1)
     @date_fin = Date.new( year=@date_annee.year, mon = 12, mday=31)
   elsif @choixPeriode == "année courante" then
     @date_annee = Date.today
     @date_debut = Date.new( year=@date_annee.year, mon = 1, mday=1)
     @date_fin = Date.new( year=@date_annee.year, mon = 12, mday=31)  
   elsif @choixPeriode == "toutes" then
     @date_debut = Date.new( year=2000, mon = 1, mday=1)
     @date_fin = Date.today          
   end
        

   @factures = Facture.find(:all,:order=>"typeDepense",:conditions =>{:date=>@date_debut..@date_fin})  
   @depenses = Depense.find(:all,:order=>"typeDepense", :conditions =>{:facture_id => @factures, :appartement_id=>@appt })
   if @choixSortie == "excel" then
     respond_to do |format|
     format.csv {render :action => "depenseSelection.csv" , :layout => false}
     end
   else  
     respond_to do |format|
         format.html {render :layout =>'bilan' }
      end
    end
  end  
 
 
  def choixDepensesImmeuble
    @depense = Depense.new
    @immeubles = Immeuble.all
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def depensesImmeuble
   @choix = params[:choix]    
   @choixPeriode = params[:periode]
   @choixTypeLoc = params[:type_loc]
   @immeuble = Immeuble.find(params[:immeuble]["immeuble"])
   if @choixTypeLoc == "meublé" then
     @apparts = Appartement.find(:all, :conditions => {:type_location => ['Meublé','MeubléElec'], :immeuble_id => @immeuble.id})
   elsif @choixTypeLoc == "non meublé" then
     @apparts = Appartement.find(:all, :conditions => {:type_location => ['nonMeublé'], :immeuble_id => @immeuble.id})
   else
     @apparts = Appartement.find(:all, :conditions => {:immeuble_id => @immeuble.id})
   end     
   @choixSortie = params[:formatSortie]
   if @choixPeriode == "Période" then
     @date_debut = Date.new( year=@choix["date_debut(1i)"].to_i, mon=@choix["date_debut(2i)"].to_i, mday=@choix["date_debut(3i)"].to_i)
     @date_fin = Date.new( year=@choix["date_fin(1i)"].to_i, mon=@choix["date_fin(2i)"].to_i, mday=@choix["date_fin(3i)"].to_i)
   elsif @choixPeriode == "annuelle" then  
     @date_annee = Date.new( year=@choix["date_debut(1i)"].to_i, mon=@choix["date_debut(2i)"].to_i, mday=@choix["date_debut(3i)"].to_i)
     @date_debut = Date.new( year=@date_annee.year, mon = 1, mday=1)
     @date_fin = Date.new( year=@date_annee.year, mon = 12, mday=31)
   elsif @choixPeriode == "année courante" then
     @date_annee = Date.today
     @date_debut = Date.new( year=@date_annee.year, mon = 1, mday=1)
     @date_fin = Date.new( year=@date_annee.year, mon = 12, mday=31)  
   elsif @choixPeriode == "toutes" then
     @date_debut = Date.new( year=2000, mon = 1, mday=1)
     @date_fin = Date.today          
   end
        

   @factures = Facture.find(:all,:order=>"typeDepense",:conditions =>{:date=>@date_debut..@date_fin})  
   @depenses = Depense.find(:all,:order=>"typeDepense", :conditions =>{:facture_id => @factures, :appartement_id => @apparts })
   if @choixSortie == "excel" then
     respond_to do |format|
     format.csv {render :action => "depenseImmeuble.csv" , :layout => false}
     end
   else  
     respond_to do |format|
         format.html {render :layout =>'bilan', :action => "depenseImmeuble.html" }
      end
    end
  end  

 
 def majTypeDepense
   @depenses = Depense.find(:all)
   for d in @depenses do
     if d.facture.typeDepense != d.typeDepense then
       d.typeDepense = d.facture.typeDepense
       d.save
     end
   end
 end

#mise à jour factures suite à ajout immeuble_id
def majImmeubleFacture
  @factures = Facture.all   
  for f in @factures do
    @depense = Depense.find(:first,  :conditions =>{:facture_id => f.id})
    if not @depense.nil? then
      f.immeuble_id = @depense.appartement.immeuble_id
      f.save
    end
  end
end
 
end


