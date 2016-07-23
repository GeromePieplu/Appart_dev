class Quittance < ActiveRecord::Base
  has_one    :bail
  #belongs_to :bail
  belongs_to :montant_loyer
  belongs_to :montant_charge
    
  validates_presence_of :bail_id, :mois, :numero, :montant_loyer_id, :montant_charge_id

    
end
