class ReservationsController < ApplicationController
  # Use a different layout
  layout 'appartements'
  #attr_reader :etat
  require 'date'
  require 'reservation_lib'
  include ReservationLib
  def etat    
    @etat = ['Ouverte','Attente confirmation','Confirmé','Payé','Annulé','obsolete','rayé']
  end
   def type_loc    
     @type_location = ['Semaine_1_paiement','Jours_1_paiement','Semaine_X_paiement','Jours_X_paiement','mois']
  end  
  

 def index
    if @current_user.login == 'admin' then
      @appartements = Appartement.find(:all , :conditions=>{:type_location=>['Meublé','MeubléElec']})
    else
       @appartements = getAppartMeuble
    end
   
    #reinitialisation du flag nouveau por les clients
    ClientsController.reinit   
    @etat = etat
    @reservations = Reservation.find(:all, :order=>"date_debut", :conditions=>{:numEtat=>3, :appartement_id =>@appartements})
    tabtest = ReservationLib.public_instance_methods
    majReservationPassees(@reservations)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reservations }
    end

 end
 
 
  def toute_reservations
    #reinitialisation du flag nouveau por les clients
    ClientsController.reinit   
    @etat = etat
    @appartements = Appartement.find(:all , :conditions=>{:type_location=>['Meublé','MeubléElec']})
    @reservations = Reservation.find(:all, :order=>"date_debut", :conditions=>{:numEtat=>3})
    majReservationPassees(@reservations)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reservations }
    end
  end

def appart_reservation
    #reinitialisation du flag nouveau por les clients
    ClientsController.reinit   
    @etat = etat
    @appartements = Appartement.find(:all, :conditions=>{:id=>params[:id]})
    @reservations = Reservation.find(:all, :order=>"date_debut", :conditions=>{:numEtat=>3, :appartement_id=>params[:id]})
    majReservationPassees(@reservations)
    respond_to do |format|
      format.html  {render :action=>:toute_reservations}
      format.xml  { render :xml => @reservations }
    end
 
end
  
  def new
    @reservation = Reservation.new
    @reservation.nombre_personne = 2
    @reservation.appartement_id = params[:id]
    @appartement = Appartement.find(@reservation.appartement_id)
    @type_location = type_loc   
    #teste si action autoriser
    test = est_autorise(@reservation.appartement, @current_user) 
    if not test
     respond_to do |format|
        flash[:notice] = 'action non autorisé.'
        format.html { redirect_to(reservations_url, :action=>"index") }
     end
    else
      # recherche si un nouveau clients existe
      @client = Client.find(:first, :conditions =>{:nouveau => 1..1000})
      if @client then @reservation.client_id = @client.id end
       respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @reservation }
      end
    end

  end

  def create
    @reservation = Reservation.new(params[:reservation])
    @reservation.date_ouverture = Time.now.to_s(:db)
    @reservation.etat = etat[0]
    @reservation.numEtat = 0
    @appartement = Appartement.find(@reservation.appartement_id)  
    @type_location = type_loc    
    @reservation.montant_total  = montantTotal @reservation
    if @reservation.date_debut.months_since(1)  < Date.today then 
      respond_to do |format|
        @reservation.errors.add(:date_debut , "la date de début est inférieure la date d'aujourd'hui" )
        format.html { render :action => "new" }
        format.xml  { render :xml =>@reservations.errors , :status => :unprocessable_entity }
      end  
    else
      respond_to do |format|
      #if    @reservation.client.save  
        if @reservation.save
           flash[:notice] = 'Reservation créée.'
          format.html {redirect_to(:controller=>"reservations", :action=>"appart_reservation", :id=>@appartement.id)}
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @reservations.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  def show
    @reservation = Reservation.find(params[:id])
    @client = Client.find(@reservation.client_id)
    @appartement = Appartement.find(@reservation.appartement.id)
    @nb_semaine_mois = if  @reservation.type_location == "mois" then
                        nombreMois @reservation 
                        else nombreSemaine @reservation end    
    @montant_total = if @reservation.montant_total.nil? then 
                        montantTotal @reservation
                    else
                      @reservation.montant_total
                    end  
    if @reservation.cautionEncaissee == "encaissée" then
      @montant_total += @appartement.montant_caution 
    end
    @paiements = Paiement.find(:all, :order =>"date_paiement DESC", :conditions => {:reservation_id => @reservation.id} )
  end
  
 def edit
   @reservation = Reservation.find(params[:id])
   @client = Client.find(@reservation.client_id)
    @type_location = type_loc  
    test = est_autorise(@reservation.appartement, @current_user) 
   if not test
     respond_to do |format|
        flash[:notice] = 'action non autorisé.'
        format.html { redirect_to(@reservation) }
     end
   end
 end
 
 def update
    @reservation = Reservation.find(params[:id])
    @reservation.montant_total  = montantTotal @reservation
    respond_to do |format|
      if @reservation.update_attributes(params[:reservation])
        @reservation = Reservation.find(params[:id])
        @reservation.montant_total  = montantTotal @reservation
        @reservation.save
        flash[:notice] = 'Réservation modifié.'
        format.html { redirect_to(:controller=>"reservations", :action=>"appart_reservation", :id=>@reservation.appartement_id) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reservation.errors, :status => :unprocessable_entity }
      end
    end
  end  

  def confirmation_cancel
     @reservation = Reservation.find(params[:id])   
  end
  
  def cancel_reservation
    @reservation = Reservation.find(params[:id])
    test = est_autorise(@reservation.appartement, @current_user) 
    if not test
      respond_to do |format|
         flash[:notice] = 'action non autorisé.'
         format.html { redirect_to(reservations_url, :action=>"index") }
      end
    else
      majOccupation(@reservation , '0')
      if @reservation.numEtat < 2 #réservation sans paiement à supprimer
         if @reservation.destroy
           respond_to do |format|
           flash[:notice] = 'Reservation annulée'
           format.html {redirect_to(:controller=>"reservations", :action=>"appart_reservation", :id=>@reservation.appartement_id)}
           end
        else
         respond_to do |format|
         flash[:notice] = 'Erreur Reservation annulée' 
         format.html {redirect_to(reservations_url, :action=>"index")}
        end
        end 
      else # réservation avec paiement marquer comme annulé
        @reservation.etat =etat[4]
        @reservation.numEtat = 4
        if @reservation.save!
           respond_to do |format|
           flash[:notice] = 'Reservation annulée'
           format.html {redirect_to(:controller=>"reservations", :action=>"appart_reservation", :id=>@reservation.appartement_id)}
           end
        else
         respond_to do |format|
         flash[:notice] = 'Erreur Reservation annulée' 
         format.html {redirect_to(reservations_url, :action=>"index")}
        end
      end
    end
  end
end

  def confirmation_terminer
     @reservation = Reservation.find(params[:id])   
  end

def terminer_reservation
    @reservation = Reservation.find(params[:id])
    test = est_autorise(@reservation.appartement, @current_user) 
    if not test
      respond_to do |format|
         flash[:notice] = 'action non autorisé.'
         format.html { redirect_to(reservations_url, :action=>"index") }
      end
    else
      @reservation.etat =etat[5]
      @reservation.numEtat = 5
      if @reservation.save!
         respond_to do |format|
         flash[:notice] = 'Reservation terminée'
         format.html {redirect_to(:controller=>"reservations", :action=>"appart_reservation", :id=>@reservation.appartement_id)}
         end
      else
         respond_to do |format|
         flash[:notice] = 'Erreur Reservation terminée' 
         format.html {redirect_to(reservations_url, :action=>"index")}
        end
      end
       
    end
end

  def confirmation_rayer
     @reservation = Reservation.find(params[:id])   
  end

def rayer_reservation
    @reservation = Reservation.find(params[:id])
    test = est_autorise(@reservation.appartement, @current_user) 
    if not test
      respond_to do |format|
         flash[:notice] = 'action non autorisé.'
         format.html { redirect_to(reservations_url, :action=>"index") }
      end
    else
      @reservation.etat =etat[6]
      @reservation.numEtat = 6
      if @reservation.save!
         respond_to do |format|
         flash[:notice] = 'Reservation rayée'
         format.html {redirect_to(:controller=>"reservations", :action=>"appart_reservation", :id=>@reservation.appartement_id)}
         end
      else
         respond_to do |format|
         flash[:notice] = 'Erreur Reservation rayée' 
         format.html {redirect_to(reservations_url, :action=>"index")}
        end
      end
       
    end
end

def changeCautionEncaissee
  @reservation = Reservation.find(params[:id])
  if @reservation.cautionEncaissee == "non encaissée" then  
      @reservation.cautionEncaissee = "encaissée" 
  else @reservation.cautionEncaissee = "non encaissée"
  end
  @reservation.montant_total  = montantTotal @reservation
  if @reservation.save!
    respond_to do |format|
    flash[:notice] = 'Reservation modifié'
    format.html {redirect_to(:action=>"show", :id=>@reservation.id)}
    end
  else
    respond_to do |format|
    flash[:notice] = 'Erreur Reservation modifé' 
    format.html {redirect_to(:action=>"show", :id=>@reservation.id)}
    end
  end    
end

def choixHisto
  @reservation = Reservation.new
  @reservation.appartement_id = params[:id]
  @appartement = Appartement.find(params[:id])

end
 
def historique
@etat = etat
retourParam = params[:reservation]
@appartement = Appartement.find(retourParam["appartement_id"])
year=retourParam["date_debut(1i)"].to_i
@from_date = Date.new( year=retourParam["date_debut(1i)"].to_i, mon=retourParam["date_debut(2i)"].to_i, mday=retourParam["date_debut(3i)"].to_i)
@to_date = Date.new( year=retourParam["date_fin(1i)"].to_i, mon=retourParam["date_fin(2i)"].to_i, mday=retourParam["date_fin(3i)"].to_i)

if @current_user.login == 'admin' then
        @reservations = Reservation.find(:all,:order=>"date_debut",:conditions =>["((date_debut between ? and ?) or (date_fin between ? and ?)) and appartement_id = ?",@from_date,@to_date,@from_date,@to_date,retourParam["appartement_id"]])
    @admin = true
else
    @reservations = Reservation.find(:all,:order=>"date_debut",:conditions =>["((date_debut between ? and ?) or (date_fin between ? and ?)) and  numEtat in (0,1,2,3,4,5) and appartement_id = ?",@from_date,@to_date,@from_date,@to_date,retourParam["appartement_id"]])
    @admin = false
end    
end


  
  
  def new_paiement
    @reservation = Reservation.find(params[:id])
    test = est_autorise(@reservation.appartement, @current_user) 
     if not test
       respond_to do |format|
          flash[:notice] = 'action non autorisé.'
          format.html { redirect_to(reservations_url, :action=>"index") }
       end
    else
      @paiement = Paiement.new
      respond_to do |format|
        format.html
        format.xml{ render :xml => @reservation }
      end
    end
  end
  


  
  def create_paiement
    @reservation = Reservation.find(params[:id])
    paiement = Paiement.new(params[:paiement])
    if paiement.save
       flash[:notice] = 'Paiement crée.'
    else
      format.html { redirect_to(reservations_url, :action=>"new_paiement") }
      format.xml  { render :xml => paiement.errors, :status => :unprocessable_entity }
    end
    @reservation.paiements << paiement
    mise_a_jour_etat(@reservation)
    @reservation.save
    respond_to do |format|
      flash[:notice] = 'Paiement crée.'
      format.html {redirect_to(:controller=>"reservations", :action=>"show", :id=>@reservation.id)}
    end
  end

  def editer_paiement
    @paiement = Paiement.find(params[:id])
    @reservation = Reservation.find(@paiement.reservation_id)
    test = est_autorise(@reservation.appartement, @current_user) 
     if not test
       respond_to do |format|
          flash[:notice] = 'action non autorisé.'
          format.html { redirect_to(reservations_url, :action=>"index") }
       end
    else
      respond_to do |format|
        format.html
        format.xml{ render :xml => @paiement }
      end
    end
  end
  
def update_paiement
     @paiement = Paiement.find(params[:id])
     respond_to do |format|
      if @paiement.update_attributes(params[:paiement])
        flash[:notice] = 'Paiement modifié.'
        format.html {redirect_to(:controller=>"reservations", :action=>"show", :id=>@paiement.reservation_id)}
        format.xml  { head :ok }
      else
        format.html { render :action => "editer_paiement" }
        format.xml  { render :xml => @paiement.errors, :status => :unprocessable_entity }
      end
    end 
end


def confirmation_delete
    @paiement = Paiement.find(params[:id])  
end

def delete_paiement
    @paiement = Paiement.find(params[:id])
    @reservation = Reservation.find(@paiement.reservation_id) 
    test = est_autorise(@reservation.appartement, @current_user) 
    if not test
      respond_to do |format|
         flash[:notice] = 'action non autorisé.'
         format.html { redirect_to(@reservation) }
      end
    else
      @paiement.destroy
      mise_a_jour_etat(@reservation)
      @reservation.save
      respond_to do |format|
        flash[:notice] = 'paiement annulé.'
        format.html { redirect_to(:action=>"show", :id=> @reservation.id) }
        format.xml  { head :ok }
      end
    end
end


def new_recue
  @reservation = Reservation.find(params[:id])
  montant_total = 0
  for element in @reservation.paiements
    montant_total += element.montant
  end
  @recue = Recue.new
  @recue.montant = montant_total
  @recue.date_debut = @reservation.date_debut
  @recue.date_fin = @reservation.date_fin
   respond_to do |format|
    format.html
    format.xml{ render :xml => @reservation }
  end
end


 def create_recue
    @reservation = Reservation.find(params[:id])
    @client = Client.find(@reservation.client_id)
    @appartement = Appartement.find(@reservation.appartement.id)
    @recue = Recue.new(params[:recue])
    @recue.reservation_id = @reservation.id
    @recue.save
    render( :layout => 'quittance' ) 
  end

  
  

  def editer_contrat
    @reservation = Reservation.find(params[:id]) 
    @appartement = Appartement.find(@reservation.appartement)
    @client = Client.find(@reservation.client)
    @proprietaire = @appartement.proprietaire #Proprietaire.find(@appartement.proprietaire_id)
    @gerant =  @appartement.gerant #Proprietaire.find(@appartement.gerant_id)
    @nb_mois = nombreMois @reservation 
    @nb_semaine =  nombreSemaine @reservation   
    @montant_total = if @reservation.montant_total.nil? then 
                        montantTotal @reservation
                    else
                      @reservation.montant_total
                    end  

    @multiPaiement = if @reservation.type_location == "Semaine_1_paiement" or @reservation.type_location == "Jours_1_paiement" then
                       0
                   elsif @nb_mois < 1.5 then
                       0
                   else 
                       1
                   end  
    @versement_mois =    if @multiPaiement == 0 then
                           0
                         elsif  @reservation.type_location == "mois" then
                           @reservation.prix 
                        elsif @reservation.type_location == "Semaine_X_paiement" or @reservation.type_location == "Jours_X_paiement" then
                           (@montant_total / @nb_mois).floor
                        end 
    # @premier_versement               
    if  @multiPaiement == 1 then
      prixPourPremiermois =  (@versement_mois /  @reservation.date_debut.end_of_month.day * (@reservation.date_debut.end_of_month.day - @reservation.date_debut.day + 1
      )).floor   
      if @reservation.date_debut.day > 15 or (prixPourPremiermois - @reservation.acompte) < 50 then 
         @premier_versement = (prixPourPremiermois + @versement_mois) - @reservation.acompte
         @dateDeuxiemePaiement = @reservation.date_debut >> 2
      else
         @premier_versement = prixPourPremiermois - @reservation.acompte
         @dateDeuxiemePaiement = @reservation.date_debut >> 1
      end
      @dateDeuxiemePaiement = @dateDeuxiemePaiement.beginning_of_month()  
      
      @solde = (@montant_total - @premier_versement) - @reservation.acompte
      prixPourDernierMois = @solde % @versement_mois
      
      @dernier_versement = if prixPourDernierMois == 0 then
                             0
                           elsif prixPourDernierMois > 50 then
                           prixPourDernierMois
                         else prixPourDernierMois + @versement_mois
                         end
      #pas de versement intermediaire si location  mois juste un premier et un dernier versement
      if (@premier_versement + @dernier_versement + @reservation.acompte) >= @montant_total then @versement_mois = 0 end                                                   
    
    else # pas de multipaiement
      @premier_versement = @montant_total - @reservation.acompte
    end


      
    if  @multiPaiement == 0 then 
      @dernier_versement = 0
    end
    
    render(:layout => false)
  end  


def valider_edition
    @reservation = Reservation.find(params[:id]) 
    test = est_autorise(@reservation.appartement, @current_user) 
    if not test
      respond_to do |format|
         flash[:notice] = 'action non autorisé.'
         format.html { redirect_to(reservations_url, :action=>"index") }
      end
    else
      @reservation.etat =etat[1]
      @reservation.numEtat = 1  
      @reservation.save
      majOccupation(@reservation , '1')  
      respond_to do |format|
         format.html {redirect_to(:controller=>"reservations", :action=>"editer_contrat", :id=>params[:id])}
       end
     end
end


def calendrier
  reservations = Reservation.find(:all,
                  :conditions =>{:appartement_id=> params[:id], :numEtat=>[0,1,2,3]}, 
                  :order=>"date_debut")
  appartement = Appartement.find(params[:id])  
  @titre = appartement.nom
  @numMois =  Date.today.month
  @nombreMois = 9   #nombre de mois pour le calendrier
  @annee = Date.today.year
  dateDebut = Date.new(@annee,@numMois,1)
  @calend_tab = calendAppart(reservations, dateDebut,dateDebut>>@nombreMois)
end

def calend_libre
  couleurs = ['#F4E39C','  #FF8C00','#FF0000','#FF0000','#F4E39C','#F4E39C']
  etatcell = ["libre", "en_cours_reservation","occupé","occupé"]
  @calend_tab = nil
  @titre = "Etat des periodes libres"
  @numMois =  Date.today.month
  @nombreMois = 9   #nombre de mois pour le calendrier
  @annee = Date.today.year
  dateDebut = Date.new(@annee,@numMois,1)
  dateFin = dateDebut>>@nombreMois
  if params[:id] == '2' then
    appartements = Appartement.find(:all , :conditions=>["type_location in ('Meublé','MeubléElec') and etat = 'en_location'"])
  else
    appartements = getAppartMeubleProprio   
  end 
  appartements.each do |app|
    reservations = Reservation.find(:all,
                    :conditions =>{:appartement_id=> app.id, :numEtat=>[0,1,2,3]}, 
                    :order=>"date_debut")
    
    if @calend_tab.nil? then
      @calend_tab = calendAppart(reservations, dateDebut,dateFin)
      @calend_tab.init_lecture
      index = 0
      cellule_tab = @calend_tab.lit_suivant
      while cellule_tab do
        if cellule_tab.etat == "occupé" then
          cellule_tab.texte_bulle = "occupé"
        else 
          cellule_tab.texte_bulle = app.nom + ": " + cellule_tab.texte_bulle
        end
        cellule_tab.controlleur = nil
        cellule_tab.action = nil
        cellule_tab.id_action = nil
        @calend_tab.tableau[index] = cellule_tab 
        index += 1
        cellule_tab = @calend_tab.lit_suivant
       end
    else
      @calend_app = calendAppart(reservations, dateDebut,dateFin)
      @calend_app.init_lecture
      @calend_tab.init_lecture
      index = 0
      cellule_tab = @calend_tab.lit_suivant
      cellule_app = @calend_app.lit_suivant
      while cellule_tab do
        if cellule_app.etat == "libre" and cellule_tab.etat != "libre" then
          cellule_tab.etat = "libre"
          cellule_tab.texte_bulle = app.nom + ": " + cellule_app.texte_bulle
          cellule_tab.couleur = cellule_app.couleur 
        elsif cellule_app.etat == "libre" and cellule_tab.etat == "libre" then
          cellule_tab.texte_bulle = cellule_tab.texte_bulle + "<br>"+ app.nom + ": " + cellule_app.texte_bulle
        elsif cellule_app.etat == "en_cours_reservation" and cellule_tab.etat == "occupé" then
          cellule_tab.etat = "en_cours_reservation"
          cellule_tab.texte_bulle = app.nom + ": " + cellule_app.texte_bulle
          cellule_tab.couleur = cellule_app.couleur 
        elsif cellule_app.etat == "en_cours_reservation" and cellule_tab.etat == "en_cours_reservation" then
          cellule_tab.texte_bulle = cellule_tab.texte_bulle + "<br>" + app.nom + ": " + cellule_app.texte_bulle
        end
        @calend_tab.tableau[index] = cellule_tab 
        index += 1
        cellule_tab = @calend_tab.lit_suivant
        cellule_app = @calend_app.lit_suivant
      end
    end
  end
  respond_to do |format|
    format.html  {render :action=>:calendrier}
    format.xml  { render :xml => @reservations }
  end
end

def choix_periode_achercher
    @reservation = Reservation.new
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reservations }
    end
end

def cherche_appart_libre
  couleurs = ['#85C630','#F0C755','#E2AD3B','#BF5C00']
  texte_etat=['libre','libre au debut','libre en cours','libre en fin']
  @etat = etat
  @tab_libre = Array.new
  @reservation = Reservation.new(params[:reservation])
  @date_debut = @reservation.date_debut
  @date_fin  = @reservation.date_fin
  choix_appart = params[:choix] 
  if choix_appart[:typeAppart] == 'tout_appart' then
    appartements = Appartement.find(:all , :conditions=>["type_location in ('Meublé','MeubléElec') and etat = 'en_location'"])
  elsif choix_appart[:typeAppart] == 'appart_gerance' then
    appartements = getAppartMeuble  
  elsif choix_appart[:typeAppart] == 'appart_proprietaire' then
    appartements = getAppartMeubleProprio    
  end
  index = 0
  appartements.each do |app|
    reservations = Reservation.find(:all,
                    :conditions =>{:appartement_id=> app.id, :numEtat=>[0,1,2,3]}, 
                    :order=>"date_debut")
    en_cours = false
    reserv_prec = nil
    reservations.each do |reserv| #pour toutes les reservations
      if (reserv.date_debut <= @date_debut) and (reserv.date_fin >= @date_fin) then  #reservation couvrant toute la période
        en_cours = true
        reserv_prec = reserv
        break
      elsif (reserv.date_debut >= @date_debut) and (reserv.date_fin <= @date_fin) then  #reservation incluse dans la période
        if not en_cours then
          debut = @date_debut
          type_libre = 1 # libre en debut de période
        else  
          debut = reserv_prec.date_fin
          type_libre = 2 # libre en cours de période
        end
        fin = reserv.date_debut
        nb_jour_libre = fin - debut
        if nb_jour_libre > 0 then
          texte = reserv.appartement.nom + " : partiellement libre du " + dateToChaineLongue(debut) + " au " + dateToChaineLongue(reserv.date_debut)
          @tab_libre[index] = Array[nb_jour_libre,reserv.appartement_id,texte,couleurs[type_libre],reserv.appartement.nom,type_libre,texte_etat[type_libre]]
          index += 1
        end
        reserv_prec = reserv
        en_cours = true
      elsif (reserv.date_fin > @date_debut) and (reserv.date_fin <= @date_fin) then #reservation commencant avant le debut
        reserv_prec = reserv
        en_cours = true
      elsif (reserv.date_debut >= @date_debut) and (reserv.date_debut < @date_fin) then #reservation se terminant après la fin
        if not en_cours then
          debut = @date_debut
          type_libre = 1 # libre en debut de période
        else  
          debut = reserv_prec.date_fin
          type_libre = 2 # libre en cours de période
        end
        fin = reserv.date_debut
        nb_jour_libre = fin - debut
        if nb_jour_libre > 0 then
          texte = reserv.appartement.nom + " : partiellement libre du " + dateToChaineLongue(debut) + " au " + dateToChaineLongue(reserv.date_debut)
          @tab_libre[index] = Array[nb_jour_libre,reserv.appartement_id,texte,couleurs[type_libre],reserv.appartement.nom,type_libre,texte_etat[type_libre]]
          index += 1
        end
        reserv_prec = reserv
        en_cours = true
      elsif (reserv.date_debut >= @date_fin) then  #reservation après la période
        if not en_cours #pas de réservation sur la période appart libre
          debut = @date_debut
          fin = @date_fin
          nb_jour_libre = fin - debut
          type_libre = 0  #libre sur toute la période
          texte = reserv.appartement.nom + " : libre du " + dateToChaineLongue(debut) + " au " + dateToChaineLongue(reserv.date_debut)
          @tab_libre[index] = Array[nb_jour_libre,reserv.appartement_id,texte,couleurs[type_libre],reserv.appartement.nom,type_libre,texte_etat[type_libre]]
          index += 1
          en_cours = true
        else
          debut = reserv_prec.date_fin
          if debut < @date_debut then debut = @date_debut end
          fin = @date_fin
          nb_jour_libre = fin - debut
          if nb_jour_libre > 0 then
            type_libre = 3 #libre en fin de période
            texte = reserv_prec.appartement.nom + " : partiellement libre du " + dateToChaineLongue(debut) + " au " + dateToChaineLongue(fin)
            @tab_libre[index] = Array[nb_jour_libre,reserv_prec.appartement_id,texte,couleurs[type_libre],reserv_prec.appartement.nom,type_libre,texte_etat[type_libre]]
            index += 1
          end
        end
        reserv_prec = reserv
        break      
      end
    end                
    if en_cours and reserv_prec.date_fin < @date_fin then  #plus de reservation avant la fin de la période
      debut = reserv_prec.date_fin
      if debut < @date_debut then debut = @date_debut end
      fin = @date_fin
      nb_jour_libre = fin - debut
      type_libre = 3 #libre en fin de période
      texte = reserv_prec.appartement.nom + " : partiellement libre du " + dateToChaineLongue(debut) + " au " + dateToChaineLongue(fin)
      @tab_libre[index] = Array[nb_jour_libre,reserv_prec.appartement_id,texte,couleurs[type_libre],reserv_prec.appartement.nom,type_libre,texte_etat[type_libre]]
      index += 1
    elsif not en_cours then # pas de réservation sur la période et après
      debut = @date_debut
      fin = @date_fin
      type_libre = 0 #libre 
      nb_jour_libre = fin - debut
      texte = app.nom + " :libre du " + dateToChaineLongue(debut) + " au " + dateToChaineLongue(fin)
      @tab_libre[index] = Array[nb_jour_libre,app.id,texte,couleurs[type_libre],app.nom,type_libre,texte_etat[type_libre]]
      index += 1
    end
  end
  @tab_libre.sort!{|x,y| x[5] <=> y[5] }
end

# simulation du montant en donnant une période et un prix par semaine
def simulation_reservation
    @reservation = Reservation.new(params[:reservation])
    @reservation.etat = etat[0]
    @reservation.numEtat = 0
    @type_location = type_loc 
    if (@reservation.prix.nil?) then
      @reservation.montant_total  =  0.0
      @nb_semaine_mois = 0
    else  
          @nb_semaine_mois = if  @reservation.type_location == "mois" then
                        nombreMois @reservation 
                        else nombreSemaine @reservation end    
     @reservation.montant_total  = montantTotal @reservation 
    end

    respond_to do |format|
      format.html
      format.xml{ render :xml => @reservation }
    end
end



  def parAppart(appart)
    return reservations.find(:all,:condition =>{:appartement_id=> appart}, :order=>"date_debut")
  end
  
  def parClient (clt)
        return reservations.find(:all,:condition =>{:client_id=> clt}, :order=>"date_debut")
  end


end



