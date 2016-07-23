class BailsController < ApplicationController
  # Use a different layout
  layout 'appartements'

  require 'date'
  def etat    
    @etat = ['nouveau','enCours','procheFin','terminer','Annulé']
  end  
  # GET /bails
  # GET /bails.xml
  def index
    if @current_user.login == 'admin' then
      @bails = Bail.find(:all)
    else
      @appartements = getAppartNonMeuble
      @bails = Bail.find(:all, :conditions=>{:etat=> 0..2, :appartement_id =>@appartements} )
    end  
    @etat = etat
    maj_etat(@bails)    
    maj_apayer(@bails)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bails }
    end
  end


  def tousBails
    @appartements = getAppartNonMeuble
    @bails = Bail.find(:all)
    @etat = etat
    respond_to do |format|
      format.html {render :action => "index"}# index.html.erb
      format.xml  { render :xml => @bails }
    end
  end
  
  
  # GET /bails/1
  # GET /bails/1.xml
  def show
    @bail = Bail.find(params[:id])
    @etat = etat
    @total_paiement = total_paiement(@bail.id,@bail.date_solde)
    @solde = @total_paiement- (@bail.solde + @bail.apayer_depuis_solde)
    @paiements = PaiementBail.find(:all, :order =>"date DESC", :conditions => {:bail_id => @bail.id} )    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bail }
    end
  end

  # GET /bails/new
  # GET /bails/new.xml
  def new
    @etat = etat    
    @bail = Bail.new
    @appartements = getAppartNonMeuble
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bail }
    end
  end

  # GET /bails/1/edit
  def edit
    @etat = etat
    @bail = Bail.find(params[:id])
  end

  # POST /bails
  # POST /bails.xml
  def create
    @bail = Bail.new(params[:bail])
    @bail.etat = 0 # 'nouveau'
    montant = params[:montant]
    montant_loyer = MontantLoyer.new
    montant_loyer.date_debut = @bail.date_debut
    montant_loyer.montant = montant[:montant_loyer]
    montant_loyer.bail_id = 0
    montant_loyer.save
    montant_charge = MontantCharge.new
    montant_charge.date_debut = @bail.date_debut
    montant_charge.montant = montant[:montant_charge]
    montant_charge.bail_id = 0  
    montant_charge.save
    @bail.montant_loyer_id = montant_loyer.id
    @bail.montant_charge_id = montant_charge.id 
    @bail.date_fin = @bail.date_debut >> 36 # ajoute 3ans
    @bail.solde = 0
    @bail.date_solde = Date.today
    @bail.apayer_depuis_solde = 0
    @bail.date_maj_apayer = @bail.date_debut << 1
    respond_to do |format|
      if @bail.save
        montant_loyer.bail_id = @bail.id
        montant_loyer.save 
        montant_charge.bail_id = @bail.id
        montant_charge.save         
        flash[:notice] = 'Bail was successfully created.'
        format.html { redirect_to(@bail) }
        format.xml  { render :xml => @bail, :status => :created, :location => @bail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bails/1
  # PUT /bails/1.xml
  def update
    @etat = etat
    @bail = Bail.find(params[:id])
    nouveau_bail =  (@etat[@bail.etat] == 'nouveau')
    old_date_solde = @bail.date_solde
    if nouveau_bail then
      @montant = params[:montant]
      @montant_loyer = MontantLoyer.find(@bail.montant_loyer_id)
      @montant_charge = MontantCharge.find(@bail.montant_charge_id)
    end  
    respond_to do |format|
      if @bail.update_attributes(params[:bail])
        if nouveau_bail then
          if @montant_loyer.montant != @montant["montant_loyer"].to_f then # nouveau loyer
            @montant_loyer.montant = @montant["montant_loyer"].to_f
            @montant_loyer.save
          end
          if @montant_charge.montant != @montant["montant_charge"].to_f then # nouveau charge
            @montant_charge.montant = @montant["montant_charge"]
            @montant_charge.save
          end
        end  
        #si date_solde modifier
        if  old_date_solde != @bail.date_solde then
          @bail.apayer_depuis_solde = 0
          if @bail.date_solde < @bail.date_debut then
            @bail.date_maj_apayer = @bail.date_debut
          else
            @bail.date_maj_apayer = @bail.date_solde
          end  
          @bail.save
        end
        flash[:notice] = 'Bail was successfully updated.'
        format.html { redirect_to(@bail) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bails/1
  # DELETE /bails/1.xml
  def destroy
    @bail = Bail.find(params[:id])
#    @bail.destroy

    respond_to do |format|
      format.html { redirect_to(bails_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def new_paiement
    @bail = Bail.find(params[:id])
    @paiement_bail = PaiementBail.new
    respond_to do |format|
      format.html
      format.xml{ render :xml => @bail }
    end
  end
  


  
  def create_paiement
    @bail = Bail.find(params[:id])
    paiement_bail = PaiementBail.new(params[:paiement_bail])
    paiement_bail.bail_id = @bail.id
    respond_to do |format|    
      if paiement_bail.save 
         maj_quittance(@bail)
         flash[:notice] = 'Paiement crée.'
         format.html {redirect_to( :action=>"show",:controller=>"bails") }
      else
        format.html { render :action => "new_paiement" } 
        format.xml  { render :xml => paiement_bail.errors, :status => :unprocessable_entity }        
      end
    end
  end

  def editer_paiement
    @paiement = PaiementBail.find(params[:id])
    @bail = Bail.find(@paiement.bail_id)
    respond_to do |format|
       format.html
       format.xml{ render :xml => @paiement }
    end
  end
  
def update_paiement
     @paiement = PaiementBail.find(params[:id])
     respond_to do |format|
      if @paiement.update_attributes(params[:paiement])
        flash[:notice] = 'Paiement modifié.'
        format.html {redirect_to(:controller=>"bails", :action=>"show", :id=>@paiement.bail_id)}
        format.xml  { head :ok }
      else
        format.html { render :action => "editer_paiement" }
        format.xml  { render :xml => @paiement.errors, :status => :unprocessable_entity }
      end
    end 
end



def confirmation_delete
    @paiement = PaiementBail.find(params[:id])  
end

def delete_paiement
    @paiement = PaiementBail.find(params[:id])
    @bail = Bail.find(@paiement.bail_id)    
    @paiement.destroy
    respond_to do |format|
      format.html { redirect_to(:action=>"show", :id=> @bail.id) }
      format.xml  { head :ok }
    end
end

#voir la quittance courrante
  def show_quittance
    @bail = Bail.find(params[:id])
    if  @bail.quittance_id.nil? then
       flash[:notice] = 'pas de quittance'
       redirect_to( :action=>"show")
    else
      @quittance = @bail.quittance
      @montant_loyer = @quittance.montant_loyer
      @montant_charge = @quittance.montant_charge 
   
      render  :layout => 'quittance' 
    end  
  end
  
#nouvelle_quittance
  def new_quittance
    @bail = Bail.find(params[:id])
    @quittance = Quittance.new
    @montant_loyers = MontantLoyer.find(:all, :conditions => {:bail_id => @bail.id}, :order => "date_debut")
    @montant_charges = MontantCharge.find(:all,:conditions => {:bail_id => @bail.id}, :order => "date_debut")    
    if @bail.quittance_id.nil? then
      @montant_loyer = @bail.montant_loyer
      @montant_charge = @bail.montant_charge
      @quittance.numero = 1
      @quittance.mois = Date.new(@montant_loyer.date_debut.year,@montant_loyer.date_debut.month,1)
      @quittance.montant_loyer_id = @bail.montant_loyer_id
      @quittance.montant_charge_id = @bail.montant_charge_id   
      
    else
        @quittance.numero = @bail.quittance.numero + 1
        @quittance.mois = @bail.quittance.mois >> 1 # mois suivant
  
      # chercher le montant loyer et charge correspondant à la date de la quittance
      loyer_precedent = MontantLoyer.new(:montant=>0, :date_debut=>@bail.date_debut)
      charge_precedent = MontantCharge.new(:montant=>0, :date_debut=>@bail.date_debut)
      @montant_loyers.each do |loyer|
        if @quittance.mois < loyer.date_debut and @montant_loyers.count > 1 then
          @montant_loyer = loyer_precedent
          break
        end
        @montant_loyer = loyer 
        loyer_precedent = loyer
      end
      @montant_charges.each do |charge|
        if @quittance.mois < charge.date_debut and @montant_charges.count > 1 then
          @montant_charge = charge_precedent
          break
        end
        @montant_charge = charge 
        charge_precedent = charge
      end
      @quittance.montant_loyer_id = @montant_loyer.id
      @quittance.montant_charge_id = @montant_charge.id    
    end    
    render :action => 'show_quittance', :layout => 'quittance' 
  end  
  
  

#choisir une quittance par son numero ou par le date
def choix_quittance
  @bail = Bail.find(params[:id])
  @quittances = Quittance.find(:all, :conditions=>{:bail_id=>@bail.id, })
end

#voir la quittance selectionner
  def show_selected_quittance
    @edit = false
    @quittance = Quittance.find(params[:id])
    @bail=Bail.find(@quittance.bail_id)
    @montant_loyer = @quittance.montant_loyer
    @montant_charge = @quittance.montant_charge 
    render :action =>'show_quittance', :layout => 'quittance' 
  end



# new_charge
  def new_charge
    @bail = Bail.find(params[:id])
    @montant_charge = MontantCharge.new
    @montant_charge.montant = @bail.montant_charge.montant
    respond_to do |format|
      format.html
      format.xml{ render :xml => @bail }
    end
  end
  
  
# new_loyer
  def new_loyer
    @bail = Bail.find(params[:id])
    @montant_loyer = MontantLoyer.new
    @montant_loyer.montant = @bail.montant_loyer.montant
    respond_to do |format|
      format.html
      format.xml{ render :xml => @bail }
    end
  end

  
#create_charge
  def create_charge
    @bail = Bail.find(params[:id])
    @montant_charge = MontantCharge.new(params[:montant_charge])
    @charge = MontantCharge.find(@bail.montant_charge_id)  
    @montant_charge.bail_id = @bail.id     
    #mise à jour de la date de fin pour les charges courrantes
    @charge.date_fin = @montant_charge.date_debut
    respond_to do |format|
      if @montant_charge.save then
        @charge.save
        flash[:notice] = 'nouvelle charges créer.'
        format.html {redirect_to( :action=>"show",:controller=>"bails") }
        format.xml  { head :ok }
      else
          format.html { render :action => "new_charge" }
          format.xml  { render :xml => @montant_charge.errors, :status => :unprocessable_entity }
      end
    end
  end

#create_loyer
  def create_loyer
    @bail = Bail.find(params[:id])
    @montant_loyer = MontantLoyer.new(params[:montant_loyer])
    @loyer = MontantLoyer.find(@bail.montant_loyer_id)  
    @montant_loyer.bail_id = @bail.id     
    #mise à jour de la date de fin pour les loyers courrantes
    @loyer.date_fin = @montant_loyer.date_debut
    respond_to do |format|
      if @montant_loyer.save then
        @loyer.save
        flash[:notice] = 'nouvelle loyers créer.'
        format.html {redirect_to( :action=>"show",:controller=>"bails") }
        format.xml  { head :ok }
      else
          format.html { render :action => "new_loyer" }
          format.xml  { render :xml => @montant_loyer.errors, :status => :unprocessable_entity }
      end
    end
  end


  def maj_quittance(bail)
  #recherche du nombre de quittance manquante
    manquante = -1
    if bail.quittance_id.nil? then 
      temp_date = bail.date_solde
      manquante = 0
    else  
      temp_date = bail.quittance.mois
      manquante = -1
    end  
    while temp_date <= Date.today do
      manquante += 1
      temp_date = temp_date >> 1
    end
  #calcul du solde actuelle

    total_paiement = total_paiement(bail.id,bail.date_solde)
    solde = total_paiement- (bail.solde + bail.apayer_depuis_solde)
    loyer = bail.montant_loyer.montant + bail.montant_charge.montant
    if solde < 0 then
  #recherche du nombre de mois non payé
     non_paye = (solde.abs / loyer).ceil    
     nb_a_creer = manquante-non_paye
   else
     paye_avance = (solde / loyer).floor   
     nb_a_creer = manquante + paye_avance
   end
  #creer toutes les nouvelles quittances des mois payer  
    nb_a_creer.times do
      create_quittance(bail)  
    end
  end
  
  
#nouvelle_quittance
  def create_quittance(bail)
    @bail = Bail.find(bail.id)
    @quittance = Quittance.new
    @montant_loyers = MontantLoyer.find(:all, :conditions => {:bail_id => @bail.id}, :order => "date_debut")
    @montant_charges = MontantCharge.find(:all,:conditions => {:bail_id => @bail.id}, :order => "date_debut")    
    if @bail.quittance_id.nil? then
      @montant_loyer = @bail.montant_loyer
      @montant_charge = @bail.montant_charge
      @quittance.numero = 1
      @quittance.mois = Date.new(@bail.date_solde.year,@bail.date_solde.month,1)
      @quittance.montant_loyer_id = @bail.montant_loyer_id
      @quittance.montant_charge_id = @bail.montant_charge_id   
      
    else
        @quittance.numero = @bail.quittance.numero + 1
        @quittance.mois = @bail.quittance.mois >> 1 # mois suivant
  
      # chercher le montant loyer et charge correspondant à la date de la quittance
      loyer_precedent = MontantLoyer.new(:montant=>0, :date_debut=>@bail.date_debut)
      charge_precedent = MontantCharge.new(:montant=>0, :date_debut=>@bail.date_debut)
      @montant_loyers.each do |loyer|
        if @quittance.mois < loyer.date_debut and @montant_loyers.count > 1 then
          @montant_loyer = loyer_precedent
          break
        end
        @montant_loyer = loyer 
        loyer_precedent = loyer
      end
      @montant_charges.each do |charge|
        if @quittance.mois < charge.date_debut and @montant_charges.count > 1 then
          @montant_charge = charge_precedent
          break
        end
        @montant_charge = charge 
        charge_precedent = charge
      end
      @quittance.montant_loyer_id = @montant_loyer.id
      @quittance.montant_charge_id = @montant_charge.id    
    end    
    @quittance.bail_id = @bail.id
    if @quittance.save    
         @bail.quittance_id = @quittance.id
         @bail.save
      end
  end


  def maj_apayer(bails)
    bails.each do |bail|
      #chercher si le montant du loyer et des charge doit changer
      loyer = bail.montant_loyer
      charge = bail.montant_charge
      #voir si le mois à changer depuis la derniere maj
      test_date = bail.date_maj_apayer >> 1
      test_date = Date.new(test_date.year,test_date.month,1)
      while test_date <= Date.today 
        if not loyer.date_fin.nil? then  # si une date fin est définie
          if test_date >= loyer.date_fin then #date de validiter du loyer atteinte 
            #chercher le nouveau loyer
            loyer = MontantLoyer.find(:first, :conditions=>{:bail_id=>bail.id,:date_debut=>test_date..Date.today})
            bail.montant_loyer_id = loyer.id
            bail.save
          end
        end
        if not charge.date_fin.nil? then  # si une date fin est définie
          if test_date >= charge.date_fin then #date de validiter des charge atteinte 
            #chercher les nouvelles charges
            charge = MontantCharge.find(:first, :conditions=>{:bail_id=>bail.id,:date_debut=>test_date..Date.today})
            bail.montant_charge_id = charge.id
            bail.save
          end
        end
        bail.apayer_depuis_solde += charge.montant
        bail.apayer_depuis_solde += loyer.montant
        bail.date_maj_apayer = Date.today
        bail.save
        test_date = test_date >> 1 #mois suivant
      end
    end
  end
end

   def maj_etat(bails)
    bails.each do |bail|
      if bail.date_fin < (Date.today) and bail.etat ==2  then
        bail.etat = 3
        bail.save
      elsif bail.date_fin < (Date.today >> 9)and bail.etat == 1 then 
        bail.etat = 2 #prochefin
        bail.save 
      elsif bail.etat == 0 and bail.paiement_bail.count > 0 then
        bail.etat = 1 
        bail.save
      end
    end
   end

def total_paiement(bail_id,depuis)
  total= 0
  paiements = PaiementBail.find(:all, :conditions =>{:date=>depuis..Date.today,:bail_id => bail_id })
  paiements.each  do |p|
  total = total + p.montant
  end  
  return total
  end

