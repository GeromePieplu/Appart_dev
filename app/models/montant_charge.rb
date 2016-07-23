class MontantCharge < ActiveRecord::Base
  has_one :bail
  has_many :quittance
  validates_presence_of :bail_id
  validates_numericality_of :montant
end
