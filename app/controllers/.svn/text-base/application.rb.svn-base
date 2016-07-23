# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
 require 'authenticated_system'
 
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
 include AuthenticatedSystem

 before_filter :login_required, :except => [:login, :logout,:showOccupation]


  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '7feb7d58112329ce8a5f33a6fddd03aa'
  


public
#retourne vrai si l'utilisateur est le propriétaire de l'appartement
   def est_autorise(appartement, user_connecte)
    autorise =false
    utilisateur = user_connecte.login
    if utilisateur == 'admin' then
      autorise = true
    elsif utilisateur == appartement.proprietaire.login_name then
      autorise = true
    elsif utilisateur == appartement.gerant.login_name then
      autorise = true
    end
    return autorise
  end  


def getProprio
  return Proprietaire.find(:first, :conditions=>{:login_name=>@current_user.login})
end

def getAppartNonMeuble
  @proprietaire = getProprio
  return Appartement.find(:all, :conditions => ["(proprietaire_id = ? or gerant_id = ?) and type_location = 'nonMeuble' and etat = 'en_location'", 
                        @proprietaire.id, @proprietaire.id],:order=>"nom" )
end

def getAppartMeuble
  @proprietaire = getProprio
  return Appartement.find(:all, :conditions => ["(proprietaire_id = ? or gerant_id = ?) and type_location in ('Meublé','MeubléElec') and etat = 'en_location'", 
                        @proprietaire.id, @proprietaire.id],:order=>"nom" )
end

def getAppartMeubleProprio
  @proprietaire = getProprio
  return Appartement.find(:all, :conditions => ["(proprietaire_id = ?) and type_location in ('Meublé','MeubléElec') and etat = 'en_location'", 
                        @proprietaire.id],:order=>"nom" )
end

def getAppart
  @proprietaire = getProprio
  return Appartement.find(:all, :conditions => ["(proprietaire_id = ? or gerant_id = ?)", 
                        @proprietaire.id, @proprietaire.id],:order=>"nom" )
end
end
