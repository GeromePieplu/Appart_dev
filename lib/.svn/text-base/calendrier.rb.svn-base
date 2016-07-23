class Calendrier
  attr_accessor :tableau
  def initialize(tab_etat,tab_couleur)
    @tableau = Array.new
    @etat_tab = tab_etat
    @couleur_tab = tab_couleur
    @index = 0
    @index_lecture = 0
  end
  
  def rempli_libre(debut,fin,texte_bulle,contoleur,action,action_id)
     rempli_cell(debut,fin,0,texte_bulle,contoleur,action,action_id)
  end
  
  def rempli_cell(debut,fin,numEtat,texte_bulle,controleur,action,action_id)
    tempdate = debut
    etat = @etat_tab[numEtat]
    couleur = @couleur_tab[numEtat]
    while tempdate < fin do
      # date, etat, couleur, texte_bulle, texte_cell, controlleur, action, id_action 
      @tableau[@index]= CellCalendrier.new(tempdate,etat, couleur, texte_bulle, tempdate.mday.to_s,controleur, action, action_id)
      @index += 1
      tempdate = tempdate + 1
    end
  end
 
  def change_cell(index,cellule)
    @tableau[index]= CellCalendrier.new(cellule.date,cellule.etat, cellule.couleur, cellule.texte_bulle, cellule.texte_cell,cellule.controlleur, cellule.action, cellule.id_action)
  end
  
  def init_lecture
    @index_lecture = -1
  end
  
  def lit_suivant
    @index_lecture += 1
    if @index_lecture <= @index then
      return @tableau[@index_lecture]
    else
      return nil
    end  
  end
  
end