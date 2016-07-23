class PaiementBail < ActiveRecord::Base
  belongs_to :bail
  validates_presence_of :bail_id, :type, :provenance
  validates_numericality_of :montant

end