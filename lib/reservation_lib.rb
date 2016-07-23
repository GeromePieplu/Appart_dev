module ReservationLib
#OUTILS ********************************************************************************
  def jour    
    @jour = [nil,'Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche']
  end 
  def mois
    @mois = [nil,"janvier","février","mars","avril","mai","juin","juillet","août","septembre","octobre","novembre","décembre"]
  end

  def jourCours    
    @jourCours = [nil,'Lun','Mar','Mer','Jeu','Ven','Sam','Dim']
  end 
  def moisCours
    @moisCours = [nil,"jan","fév","mar","avr","mai","juin","juil","aoû","sep","oct","nov","déc"]
  end

def dateToChaineLongue (date)
  return jour[date.cwday] + " " + date.mday.to_s + " " + mois[date.mon] + " " + date.year.to_s
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

#initialize(etat, texte_bulle, texte_cell, controlleur, action, id_action )
  def calendAppart(reservations,date_debut,date_fin)
    controleur = "reservations"
    action= "show"
    couleurs = ['#85C630','#E2CA1A','#DB2218','#DB2218','#F4E39C','#F4E39C']
    etatcell = ["libre", "en_cours_reservation","occupé","occupé"]  
    tempDate = date_debut
    reserv_en_cours = false
    reserv_prec = nil
    calend_tab = Calendrier.new(etatcell,couleurs)
    en_cours = false
    reservations.each do |reserv| #pour toutes les reservations
      if reserv.numEtat == 0 then reserv.numEtat = 1 end
      action_id = reserv.id
      if (reserv.date_debut >= date_debut) and (reserv.date_fin <= date_fin) then
        en_cours = true
      #remplissage des jours libre entre la reservation et la reservation précédente
        #test si premiere reservations touvé pour la période
        if not defined? reserv_prec or reserv_prec.nil? then
          debut = date_debut
          fin = reserv.date_debut
        else
          debut = reserv_prec.date_fin
          fin = reserv.date_debut
        end
        #remplissage des cellule libre
        texte_bulle = "libre du " + dateToChaineLongue(debut) + " au " + dateToChaineLongue(fin) 
        if debut != fin then calend_tab.rempli_libre(debut,fin,texte_bulle,nil,nil,nil) end
        #remplissage de la reservation  
        calend_tab.rempli_cell(reserv.date_debut,reserv.date_fin,reserv.numEtat,getBulleReserv(reserv),controleur,action,action_id)
      elsif (reserv.date_fin >= date_debut) and (reserv.date_fin <= date_fin) then
        en_cours = true
        #remplissage de la reservation  
        calend_tab.rempli_cell(date_debut,reserv.date_fin,reserv.numEtat,getBulleReserv(reserv),controleur,action,action_id)
      elsif (reserv.date_debut >= date_debut) and (reserv.date_debut <= date_fin) then
        en_cours = true
      #remplissage des jours libre entre la reservation et la reservation précédente
        #test si premiere reservations touvé pour la période
        if reserv_prec.nil? then
          debut = date_debut
          fin = reserv.date_debut
        else
          debut = reserv_prec.date_fin
          fin = reserv.date_debut
        end
        #remplissage des cellule libre
        texte_bulle = "libre du " + dateToChaineLongue(debut) + " au " + dateToChaineLongue(fin) 
        if debut != fin then calend_tab.rempli_libre(debut,fin,texte_bulle,nil,nil,nil) end
      
        #remplissage de la reservation  
        calend_tab.rempli_cell(reserv.date_debut,date_fin,reserv.numEtat,getBulleReserv(reserv),controleur,action,action_id)
      elsif (reserv.date_debut <= date_debut) and (reserv.date_fin >= date_fin) then
        en_cours = true
          debut = date_debut
          fin = date_fin
        #remplissage de la reservation  
        calend_tab.rempli_cell(reserv.date_debut,date_fin,reserv.numEtat,getBulleReserv(reserv),controleur,action,action_id)
      else 
        if en_cours then break end      
      end
      if en_cours then reserv_prec = reserv end
    end
   #remplissage des jours libre entre la derniere reservation et la fin
    #test si premiere reservations touvé pour la période
    if reserv_prec.nil? then
      debut = date_debut
      fin = date_fin
    else
      debut = reserv_prec.date_fin
      fin = date_fin
    end
    #remplissage des cellule libre
    texte_bulle = "libre du " + dateToChaineLongue(debut) + " au " + dateToChaineLongue(fin) 
    if debut != fin then 
      calend_tab.rempli_libre(debut,fin,texte_bulle,nil,nil,nil) 
    end
    return calend_tab  
  end

  def nombreSemaine(reservation)
        #calcul du nombre de semaine
    @type_location = type_loc        
    nbJours = reservation.date_fin - reservation.date_debut
    jourDeb = reservation.date_debut.cwday
    jourFin = reservation.date_fin.cwday
    nbSemaineTheo = (nbJours/7).floor
    resteNbJours = nbJours - (nbSemaineTheo * 7)
    if reservation.type_location == "Semaine_1_paiement" or  reservation.type_location == "Semaine_X_paiement" then
      if nbJours < 8
        nb_semaine = 1.0
      else
        #ajustement du nombre de jours (pas de semaine suppl si arrivé le vendredi)
        if jourDeb == 5 
          nbJours = nbJours - 1
        #rajouter le nombre de jours pour une semaine complete  
        elsif jourDeb == 7
          nbJours = nbJours + 1
        elsif  (1..4)  === jourDeb
          nbJours = nbJours + jourDeb + 1 
        end
         # pas de semaine supplementaire si parti le lundi
        if jourFin == 7 
          nbJours = nbJours - 1 
        elsif jourFin == 1
          nbJours = nbJours - 2
        #rajouter le nombre de jours pour une semaine complete          
        elsif  (2..5)  === jourFin
          nbJours = nbJours + (6 -jourFin) 
        end
        nb_semaine = (nbJours / 7).floor
      end  
      if nb_semaine == 0 
        nb_semaine = 1.0   
      end
      if nbSemaineTheo >= nb_semaine then
        nb_semaine = nb_semaine + (resteNbJours / 7.0)
      end
    else
      nb_semaine = nbSemaineTheo + (resteNbJours / 7.0)
    end  
    return nb_semaine
    end

#calcul le nombre de mois entre 2 dates retourne un reel 
def nombreMois(reservation, montant = false)
  nb_Mois = nombreMoisPeriode(reservation.date_debut, reservation.date_fin, montant)
  return nb_Mois
end

def nombreMoisPeriode(date_deb,date_fin, montant = false)
   
  nb_Mois = 0.0
  nb_mois_sup = 0.0
  nb_Jours_debut = if date_deb.day == 1 then 0 
          else date_deb.end_of_month.day - date_deb.day + 1
                  end
  tempdate = if nb_Jours_debut == 0 then date_deb   
             else date_deb >> 1       
             end   
  tempdate = tempdate.beginning_of_month                  
  while (tempdate >> 1) <=  date_fin
    tempdate = tempdate >> 1
    nb_Mois = nb_Mois + 1
  end
  nb_Jours_fin = date_fin - tempdate
  if montant then
    #nombre de jour du mois de debut de période
    nb_Jours_mois_debut = date_deb.end_of_month.day  
    nb_Jours_mois_fin = date_fin.end_of_month.day
    
    nb_mois_sup = nb_Jours_debut / (nb_Jours_mois_debut *1.0)
    nb_mois_sup +=  nb_Jours_fin / (nb_Jours_mois_fin * 1.0 )
    nb_Mois = nb_Mois + nb_mois_sup
  else
    nb_Jours = nb_Jours_debut + nb_Jours_fin
    nb_Mois = nb_Mois +(nb_Jours / 30)
  end  
  return nb_Mois 
end

#calcul du montant total pour la reservation
def montantTotal (reservation)
  montant_total = 0.0
  nbSemaineouMois = if  reservation.type_location == "mois" then
                        nombreMois(reservation, true)
                        else nombreSemaine reservation end
    montant_total = (reservation.prix * nbSemaineouMois).floor
  return montant_total
end



def mise_a_jour_etat(reservation)
    montant_total = 0
    if reservation.montant_total.nil? then 
        reservation.montant_total = montantTotal reservation
        reservation.save
    end  
      #tester si le montant de changer l'etat de la reservation
    for element in reservation.paiements
      montant_total += element.montant
    end
    if montant_total >= reservation.montant_total
      reservation.etat = etat[3]
      reservation.numEtat = 3
      majOccupation(reservation , '3')
    elsif montant_total >= reservation.acompte
      reservation.etat = etat[2]
      reservation.numEtat = 2
      majOccupation(reservation , '2')
    else
       reservation.etat = etat[1]
      reservation.numEtat = 1
      majOccupation(reservation , '1')     
    end
end

# met a jours les champs  @appartement.occupationAnneePaire
#                         @appartement.occupationAnneeImpaire
#avec le caratère occ
def   majOccupation(reservation , occ)
  @appartement = Appartement.find(reservation.appartement_id) 
  date_debut = reservation.date_debut
  anCourPaire = (Date.today.year  % 2 == 0) # annee actuelle paire ?
  anPair = false
if reservation.date_fin.year >= Date.today.year then 
  #chercher la date du 1er mardi ( si mardi occupé semaine occupé)
  if [2..4] === date_debut.cwday then
    date_debut = date_debut - (date_debut.cwday- 2)
  elsif 5 == date_debut.cwday then  
   date_debut = date_debut + 4
  elsif 6 == date_debut.cwday then  
   date_debut = date_debut + 3
  elsif 7 == date_debut.cwday then  
   date_debut = date_debut + 2
  elsif 1 == date_debut.cwday then  
   date_debut = date_debut + 1
  end
  #chercher le 1er mardi pour l'annee courante
  while date_debut.year < Date.today.year and date_debut.cweek > 1
    date_debut = date_debut + 7
  end  
  semDeb = date_debut.cweek
  if semDeb == 1 then
    #si 1ere semaine de l'annee regarder l'anne du dernier jour de la semaine
    anPair = ((date_debut+5).year % 2 == 0)
  else
    if date_debut.year % 2 == 0 then
      anPair = true
    else
      anPair = false
    end
  end
  nbSemAnCour = 0
  #si debut reservation sur l'annee courante
  if anCourPaire == anPair then
    #calcul du nombre de semaine sur l'annee courante

    while date_debut <= reservation.date_fin
      nbSemAnCour +=1
      date_debut += 7
      if date_debut.cweek == 1 then break end# fin si debut anne suivante 
    end
  end
  #calcul du nombre de semaine sur l'annee suivante
  nbSemAnSuiv = 0
  while date_debut <= reservation.date_fin
    nbSemAnSuiv += 1
    date_debut += 7
    if date_debut.cweek == 1 then break end # fin si debut anne hors tableau
  end

  chaineAnPaire = @appartement.occupationAnneePaire
  chaineAnImpaire = @appartement.occupationAnneeImpaire
  #chaineAnPaire = "0" * 52
  #chaineAnImpaire = "0" * 52

  if (anCourPaire)
    if nbSemAnCour == 0 then
      if nbSemAnSuiv > 0 then #reservation sur l'annee suivante
        chaineAnImpaire = insertReplaceString(chaineAnImpaire ,occ * nbSemAnSuiv , semDeb ) 
      end        
    else
      chaineAnPaire = insertReplaceString( chaineAnPaire , occ * nbSemAnCour, semDeb) 
      if nbSemAnSuiv > 0 then # et se terminant l'annee suivante
        chaineAnImpaire = insertReplaceString(chaineAnImpaire ,occ * nbSemAnSuiv , 0 ) 
      end 
    end
  else
    if nbSemAnCour == 0 then
      if nbSemAnSuiv > 0 then #reservation sur l'annee suivante
        chaineAnPaire = insertReplaceString(chaineAnPaire ,occ * nbSemAnSuiv , semDeb ) 
      end
    else #reservation commencant cette annee 
      chaineAnImpaire = insertReplaceString( chaineAnImpaire , occ * nbSemAnCour, semDeb) 
      if nbSemAnSuiv > 0 then # et se terminant l'annee suivante
        chaineAnPaire = insertReplaceString(chaineAnPaire ,occ * nbSemAnSuiv , 0 ) 
      end
    end
  end

  
      @appartement.occupationAnneePaire = chaineAnPaire
      @appartement.occupationAnneeImpaire = chaineAnImpaire
      @appartement.save
end
end

#si la date de fin de la reservation est dans le passé etat => obsolete
def majReservationPassees(reservations)
  maintenant = Date.today 
  for r in reservations
    if r.numEtat == 3 # reservation payé et terminé => obsolete
      res = r.date_fin <=> maintenant
      if res == -1  # reservation passée
        r.etat = etat[5]
        r.numEtat = 5
        r.save
        majOccupation( r , '0')
      else 
        break
      end
    end
  end
end


#insert en ecrasant une chaine dans une autre
def insertReplaceString(chaineInitiale,chaineInsert,position)
  error = false
  #test des differend cas
  if (position < 0 or (position -1 + chaineInsert.length) > chaineInitiale.length )
   chaine = chaineInitiale
  else
    if position == 0
      chaine = chaineInsert
    else
      chaine = chaineInitiale[0,position -1 ] + chaineInsert
    end
    if chaine.length < chaineInitiale.length
      chaine += chaineInitiale[chaine.length,chaineInitiale.length - chaine.length ]
    end
  end
  return chaine
end



#outils utilisé pour restauration des champs appartement.occupationAnneePaire et impaire et numEtat
def upgradeOccupation
  @appartements = Appartement.find(:all) 
  for a in @appartements
    a.occupationAnneePaire = "0" * 53
    a.occupationAnneeImpaire = "0" * 53
    a.save
  end
  @reservations = Reservation.find(:all, :order=>"date_debut")
  for r in @reservations
     if (r.etat <=> 'Ouverte') == 0
       r.numEtat = 0
     elsif (r.etat <=> 'Attente confirmation') == 0
       r.numEtat = 1
       majOccupation(r , '1')
     elsif (r.etat <=> 'Confirmé') == 0
       r.numEtat = 2
       majOccupation(r , '2')
     elsif (r.etat <=> 'Payé') == 0
       r.numEtat = 3
       majOccupation(r , '3')
     elsif (r.etat <=> 'Annulé') == 0
       r.numEtat = 4
       #majOccupation(r , '0')
     elsif (r.etat <=> 'obsolete') == 0
       r.numEtat = 5
       #majOccupation(r , '0')
     end
     r.save 
    end
end
end

