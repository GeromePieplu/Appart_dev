module ReservationsHelper

  
  def couleurs    
    @couleurs = ['#F4E39C','  #FF8C00','#FF0000','#FF0000','#F4E39C','#F4E39C']
  end  
  
  def couleursReserv    
    @couleursReserv = ['#F4E39C','  #F4A460','#00FF00','  #CD5C5C','#006666','#FFFFFF']
  end  
  def getCouleur(etat)
    return couleurs[etat.to_i]
  end
  
  def getCouleurReserv(etat)
    return couleursReserv[etat.to_i]
  end
  
  def getCouleurEtatDate (reserv)
    if not reserv then etat = 5 else etat = reserv.numEtat end
    return getCouleurReserv(etat)  
  end

  def getNumSem(d)
    semDeb = d.cweek
    if d.cwday > 5
      semDeb += 1 # rajouter 1 si samedi ou dimanche
    end
    if semDeb > 52
      semDeb = 1
    end
    return semDeb
  end
  
  def getdateSemaine(n , annee)
     jd = Date.existw?( annee, n , 4)
     if jd then
     dateFinSem = Date.new1(jd)  
     dateFinSem += 2
     dateDebutSem = dateFinSem - 7
     return "du " + dateToChaineLongue(dateDebutSem) + " au " + dateToChaineLongue(dateFinSem)
   else
     return ""
   end  
  end
  
  
# retourne le nombre de jours ocuppé par une reservation sur une période donnée
def getNbJoursPeriode(reservation, date_debut, date_fin)
  nbJours = 0
  # si la reservation est effective 
  if reservation.numEtat == 2 or reservation.numEtat == 3 or reservation.numEtat >= 5 then
    if reservation.date_debut >= date_debut and reservation.date_debut <= date_fin then
      if reservation.date_fin <= date_fin then
        nbJours = (reservation.date_fin - reservation.date_debut) + 1
     else
        nbJours = (date_fin - reservation.date_debut) + 1
     end  
    elsif  reservation.date_fin >= date_debut and reservation.date_fin <= date_fin then 
     nbJours = (reservation.date_fin - date_debut) + 1
    elsif  reservation.date_debut < date_debut and reservation.date_fin > date_fin then 
     nbJours = (date_fin - date_debut) + 1
   end 
  end 
  return nbJours
end
 
    # return la revervation contenant la date en cours ou nil
  def getReservCourrante(reservations, dateCour)
    reservations.each do |r| 
      res = dateCour <=> r.date_fin
      if res < 1
        if dateCour.between?(r.date_debut,r.date_fin)
          return r
        else 
          return nil  
        end
      end
    end
    return nil
  end
  def getBulleReserv(reserv)
    texte = ""
    if reserv
      client  = Client.find(reserv.client)
      texte = client.prenom + " " + client.nom + "<br>"
      texte = texte + "du " + dateToChaineLongue(reserv.date_debut) + 
                      " au " + dateToChaineLongue(reserv.date_fin) + "<br>"
      texte = texte + "etat : " + reserv.etat  + "<br>"
      if reserv.commentaire 
         texte = texte + " " + reserv.commentaire
      end
    else
     texte = "libre"
   end
   return texte
  end

def isToutEspece(reserv)
  texte = 'oui'
  reserv.paiements.each do |paiement|
    if paiement.type_paiement != 'Espèce' 
      texte = 'non'
    end  
  end
  return texte
end
  
  

end
