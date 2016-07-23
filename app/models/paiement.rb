class Paiement < ActiveRecord::Base
  belongs_to :reservation
  #belongs_to :loyer
  validates_numericality_of :montant
end
