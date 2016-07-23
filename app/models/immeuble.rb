class Immeuble < ActiveRecord::Base
  has_many :appartements
  has_many :factures
  validates_format_of :code_postal, :with=>/\A[0-9]{5}\Z/, :if=>:code_postal? 
  validates_presence_of :nom
end
