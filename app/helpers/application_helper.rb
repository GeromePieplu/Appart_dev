# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
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

def dateToChaine (date)
  return "%02d"% date.mday + "/" + "%02d"% date.mon + "/" + date.year.to_s
end

def dateToChaineCourte (date)
  anneeCourte = date.year - 2000
  
  return jourCours[date.cwday] + " " +  "%02d"% date.mday + " " + moisCours[date.mon] + " " + "%02d"% anneeCourte
end

def getNomMois(m)
  return mois[m]
end

def formatMonetaire(montant)
  if montant < 0 then
    couleurstyle = "<span style='color:red ; font-size:16px'>"
  else
    couleurstyle = "<span style='font-size:16px'>"
  end
  montant_str = couleurstyle + number_with_precision(montant, :precision=>2).to_s + "€" + "</span>"
  return montant_str
end

def formatCsv(montant)
  montant_str = number_with_precision(montant, :separator=>",").to_s
  return montant_str 
end
  
end
