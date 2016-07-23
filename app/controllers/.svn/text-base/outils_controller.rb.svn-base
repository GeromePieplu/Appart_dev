class OutilsController < ApplicationController
  # Use a different layout
  layout 'appartements'
  require 'reservation_lib'
  include ReservationLib
    
def index
  
end

  
def choixBilan
    @reservation = Reservation.new
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reservations }
    end
  #struct_bilan = Struct.new("choix_bilan",:proprio_id,:date_debut,:date_fin)
  #@choix = {:proprio_id => 1,:date_debut => Date.new(Date.today.year,1,1),:date_fin => Date.today} 
end
 
 
def bilan
  @choix = params[:choix]
  @type_location = params[:type_location]
  proprio_id = @choix["proprio_id"]
  @date_debut = Date.new( year=@choix["date_debut(1i)"].to_i, mon=@choix["date_debut(2i)"].to_i, mday=@choix["date_debut(3i)"].to_i)
  @date_fin = Date.new( year=@choix["date_fin(1i)"].to_i, mon=@choix["date_fin(2i)"].to_i, mday=@choix["date_fin(3i)"].to_i)
  date_fin = Date.today
  if date_fin > @date_fin then date_fin = @date_fin end
  @nb_mois = nombreMoisPeriode(@date_debut,date_fin)
  @proprietaire = Proprietaire.find(@choix["proprio_id"])
  if @type_location == "Meuble" then
    @appartements = Appartement.find(:all ,:conditions =>{:proprietaire_id =>proprio_id, :type_location=>['Meublé','MeubléElec']})
  elsif @type_location == "vide" then
    @appartements = Appartement.find(:all ,:conditions =>{:proprietaire_id =>proprio_id, :type_location=>['nonMeublé']})
  else
    @appartements = Appartement.find(:all, :order=>"type_location", :conditions =>{:proprietaire_id =>proprio_id})
  end  
  if @current_user.login == 'admin' then
    @admin = true
  else
    @admin = false
  end 
end

def choixBilanAnnuel
    @reservation = Reservation.new
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reservations }
    end

end

def bilanAnnuel
  
  @choix = params[:choix]
  @type_location = params[:type_location]
  @date_annee = params[:date]
  proprio_id = @choix["proprio_id"]
  @date_debut = Date.new( year=@date_annee["year"].to_i, mon = 1, mday=1)
  @date_fin = Date.new( year=@date_annee["year"].to_i, mon = 12, mday=31)
  date_fin = Date.today
  if date_fin > @date_fin then date_fin = @date_fin end
  @nb_mois = nombreMoisPeriode(@date_debut,date_fin)
  @proprietaire = Proprietaire.find(@choix["proprio_id"])
  if @type_location == "Meuble" then
    @appartements = Appartement.find(:all ,:conditions =>{:proprietaire_id =>proprio_id, :type_location=>['Meublé','MeubléElec']})
  elsif @type_location == "vide" then
    @appartements = Appartement.find(:all ,:conditions =>{:proprietaire_id =>proprio_id, :type_location=>['nonMeublé']})
  else
    @appartements = Appartement.find(:all, :order=>"type_location", :conditions =>{:proprietaire_id =>proprio_id})
  end  
  if @current_user.login == 'admin' then
    @admin = true
  else
    @admin = false
  end 
  respond_to do |format|
       format.html {render :action => "bilan" , :layout =>'bilan' }
    end
end

def choixBilanPaiement
    @reservation = Reservation.new
    respond_to do |format|
    format.html # index.html.erb
    end
end

def bilanPaiement
   @choix = params[:choix]    
   @choixPeriode = params[:periode]
   @appartements = Appartement.find(:all ,:conditions =>{:proprietaire_id => 3, :type_location=>['Meublé','MeubléElec']})
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
        
   @reservations = Reservation.find(:all,:order=>"date_debut",:conditions =>{:numEtat=>[0,1,2,3,4,5], :appartement_id => @appartements })
   @paiements = Paiement.find(:all,:order=>:type_paiement , :conditions =>{:date_paiement => @date_debut..@date_fin, :reservation_id => @reservations })
     
   if @choixSortie == "excel" then
     respond_to do |format|
     format.csv {render :action => "bilanPaiement.csv" , :layout => false}
     end
   else  
     respond_to do |format|
         format.html {render :layout =>'bilan', :action => "bilanPaiement.html" }
      end
    end
  
end

def choixHisto
  @reservation = Reservation.new


end
 
def historique
retourParam = params[:reservation]
@appartement = Appartement.find(retourParam["appartement_id"])
year=retourParam["date_debut(1i)"].to_i
@from_date = Date.new( year=retourParam["date_debut(1i)"].to_i, mon=retourParam["date_debut(2i)"].to_i, mday=retourParam["date_debut(3i)"].to_i)
@to_date = Date.new( year=retourParam["date_fin(1i)"].to_i, mon=retourParam["date_fin(2i)"].to_i, mday=retourParam["date_fin(3i)"].to_i)
if @current_user.login == 'admin' then
        @reservations = Reservation.find(:all,:order=>"date_debut",:conditions =>["((date_debut between ? and ?) or (date_fin between ? and ?)) and appartement_id = ?",@from_date,@to_date,@from_date,@to_date,retourParam["appartement_id"]])
    @admin = true
else
  #or date_fin between ? and ?     { :numEtat=>[0,1,2,3,4,5], :appartement_id=> retourParam["appartement_id" ]}
    @reservations = Reservation.find(:all,:order=>"date_debut",:conditions =>["((date_debut between ? and ?) or (date_fin between ? and ?)) and  numEtat in (0,1,2,3,4,5) and appartement_id = ?",@from_date,@to_date,@from_date,@to_date,retourParam["appartement_id"]])
    @admin = false
end    
  respond_to do |format|
       format.html {render :layout =>'bilan' }
    end
end

def choixHistoAnnuel
  @reservation = Reservation.new


end

def historiqueAnnuel
retourParam = params[:reservation]
date_année =  params[:date]
@choixSortie = params[:formatSortie]
@appartement = Appartement.find(retourParam["appartement_id"])

@from_date = Date.new( year=date_année["year"].to_i, mon = 1, mday=1)
@to_date = Date.new( year=date_année["year"].to_i, mon = 12, mday=31)
if @current_user.login == 'admin' then
        @reservations = Reservation.find(:all,:order=>"date_debut",:conditions =>["((date_debut between ? and ?) or (date_fin between ? and ?)) and appartement_id = ?",@from_date,@to_date,@from_date,@to_date,retourParam["appartement_id"]])
    @admin = true
else
  #or date_fin between ? and ?     { :numEtat=>[0,1,2,3,4,5], :appartement_id=> retourParam["appartement_id" ]}
    @reservations = Reservation.find(:all,:order=>"date_debut",:conditions =>["((date_debut between ? and ?) or (date_fin between ? and ?)) and  numEtat in (0,1,2,3,4,5) and appartement_id = ?",@from_date,@to_date,@from_date,@to_date,retourParam["appartement_id"]])
    @admin = false
end    
   if @choixSortie == "excel" then
     respond_to do |format|
     format.csv {render :action => "historique.csv" , :layout => false}
     end
   elsif @choixSortie == "excelpaiements" then
     respond_to do |format|
     format.csv {render :action => "historiquePaiements.csv" , :layout => false}
     end
   else   
    respond_to do |format|
         format.html {render :action => "historique" , :layout =>'bilan' }
      end
  end    
end

  def choixRecettesImmeuble
    @reservation = Reservation.new
    @immeubles = Immeuble.all
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def recettesImmeuble
   @choix = params[:choix]    
   @choixPeriode = params[:periode]
   @choixTypeLoc = params[:type_loc]
   @immeuble = Immeuble.find(params[:immeuble]["immeuble"])
   @appartsMeubl = Appartement.find(:all, :conditions => {:type_location => ['Meublé','MeubléElec'], :immeuble_id => @immeuble.id})
   @appartsNonMeubl = Appartement.find(:all, :conditions => {:type_location => ['nonMeublé'], :immeuble_id => @immeuble.id})
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
        
   if @choixTypeLoc == "meublé" or @choixTypeLoc =="toute" then
     @reservations = Reservation.find(:all,:order=>"date_debut",:conditions =>{:numEtat=>[0,1,2,3,4,5], :appartement_id => @appartsMeubl })
     @paiements = Paiement.find(:all,:order=>"date_paiement", :conditions =>{:date_paiement => @date_debut..@date_fin, :reservation_id => @reservations })
   end
   if @choixTypeLoc == "non meublé" or @choixTypeLoc =="toute" then
     @bails = Bail.find(:all,:order=>"date_debut",:conditions =>{:appartement_id => @appartsNonMeubl })
     @paiementsBail = PaiementBail.find(:all,:order=>"date", :conditions =>{:date => @date_debut..@date_fin, :bail_id => @bails })
   end
    
   if @choixSortie == "excel" then
     respond_to do |format|
     format.csv {render :action => "recettesImmeuble.csv" , :layout => false}
     end
   else  
     respond_to do |format|
         format.html {render :layout =>'bilan', :action => "recettesImmeuble.html" }
      end
    end
  end  


end
