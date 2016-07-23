class Facture < ActiveRecord::Base
has_many :depenses
belongs_to :immeuble

validates_presence_of  :date, :typeDepense, :emetteur
validates_numericality_of :montant
end