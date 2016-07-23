class Depense < ActiveRecord::Base
belongs_to :appartement
belongs_to :facture
validates_presence_of :appartement_id, :facture_id
validates_numericality_of  :montant_reparti
end
