module BailsHelper

  def couleursBail  
    @couleursBail = ['#F4E39C','#96CA2D','  #F40000','  #CD5C5C','#006666','#FFFFFF']
  end  
  
  def getCouleurBail(etat)
    return couleursBail[etat.to_i]
  end
    
  def calcul_solde_courrant(bail)
     #calcul du total charge et total loyer du depuis le debut du bail
     total_loyer = 0
     total_charge = 0
     #calcul total loyer
     montant_loyers = MontantLoyer.find(:all, :conditions => {:bail_id => bail.id}  , :order => "date_debut")
     nb_loyers = montant_loyers.count
     save_loyer = MontantLoyer.new
     premier_passage = true
     date_en_cours = bail.date_solde
     montant_loyers.each  do |loyer|
       if premier_passage and nb_loyers > 1 then #premier passage mémorisation du loyer et boucle suivante
         premier_passage = false
         save_loyer = loyer  
         next   
       else
         #chercher la date de fin de validiter du loyer
         if nb_loyers  == 1 then #pas de changement de loyer depuis le début du bail
           @date_fin = Date.today
           save_loyer = loyer  
         else
           @date_fin = loyer.date_debut
         end
         nb_loyers -= 1
       end
       while date_en_cours < @date_fin
         total_loyer = total_loyer + save_loyer.montant
         date_en_cours = date_en_cours >> 1
       end
       save_loyer = loyer  
     end
     #calcul total charge
     montant_charges = MontantCharge.find(:all, :conditions => {:bail_id => bail.id}  , :order => "date_debut")
     nb_charges = montant_charges.count
     save_charge = MontantCharge.new
     premier_passage = true
     date_en_cours = bail.date_solde
     montant_charges.each  do |charge|
       if premier_passage and nb_charges > 1 then #premier passage mémorisation du charge et boucle suivante
         premier_passage = false
         save_charge = charge  
         next   
       else
         #chercher la date de fin de validiter du charge
         if nb_charges  == 1 then #pas de changement de charge depuis le début du bail
           @date_fin = Date.today
           save_charge = charge  
         else
           @date_fin = charge.date_debut
         end
         nb_charges -= 1
       end
       while date_en_cours < @date_fin
         total_charge = total_charge + save_charge.montant
         date_en_cours = date_en_cours >> 1
       end
       save_charge = charge  
     end
    total_paiement = bail.paiement_bail.sum("montant")  #, :conditions => date > bail.date_solde )
    if total_paiement.nil? then total_paiement = 0 end
    return ((total_loyer + total_charge)- total_paiement) + bail.solde
  end
  
end
