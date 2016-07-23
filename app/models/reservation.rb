class Reservation < ActiveRecord::Base
  belongs_to :client
  belongs_to :appartement
  has_many :paiements
  
  named_scope :active, :conditions => {:etat => ['Ouverte','Attente confirmation','Confirmé','Payé']}
  
  validates_presence_of  :client_id , :appartement_id
  validates_numericality_of  :prix , :acompte

  def validate
      @reservTotest = Reservation.find(:all, :conditions => { :appartement_id => appartement_id,
                                             :etat => ['Ouverte','Attente confirmation','Confirmé','Payé'] } , :order => 'date_debut')
      res = date_debut <=> date_fin
      if res > -1
        errors.add(:date_fin , "la date de fin est inférieure ou égale à la date de début" )
      end
    err = false  
    for c in @reservTotest
      if c.id != id  # pas de test sur la meme reservation
        res = c.date_debut <=> date_debut
        if res == -1 #si date_debut inferieure à date_debut de la periode alors date fin inferieure ou egale à date debut periode
          res = c.date_fin <=> date_debut
          if res > 0
            errors.add(:date_debut , "déja louer sur cette période" )
            err = true
            break
          end
        end
        res = c.date_debut <=> date_debut
        if res > -1 #si date_debut superieure à date_debut de la periode alors date debut superieure à date fin periode
          res = c.date_debut <=> date_fin
          if res < 0
            errors.add(:date_debut , "déja louer sur cette période" )
            err = true
            break
          end
        end
        if err == true
          return
        end  
      end
    end
  end
end

