class Client < ActiveRecord::Base
  validates_presence_of :nom 
  validates_uniqueness_of :nom, :scope => [:prenom]
  def name_with_initial
      "#{nom}    #{prenom}"
  end

end
