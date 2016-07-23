class Appartement < ActiveRecord::Base
  belongs_to :proprietaire
  belongs_to :gerant, :class_name => "Proprietaire" 
  belongs_to :immeuble
  has_many :bails
  has_many :reservations
  has_many :depenses
  validates_format_of :code_postal, :with=>/\A[0-9]{5}\Z/, :if=>:code_postal? 
  validates_presence_of :nom
  
    def name_with_initial
      "#{prenom}  #{nom}"
    end
end
