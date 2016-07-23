class Bail < ActiveRecord::Base
  belongs_to :locataire, :class_name => "Client", :foreign_key=>"locataire_id"
  belongs_to :appartement
  belongs_to :montant_loyer
  belongs_to :montant_charge
  belongs_to :quittance
 # has_many :quittance
  has_many :paiement_bail
  
   validates_presence_of :locataire_id, :appartement_id, :montant_loyer_id, :montant_charge_id
end
