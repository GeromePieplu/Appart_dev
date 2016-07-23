class AjoutTableauOccupation < ActiveRecord::Migration
  def self.up
    #ajout de colonne codant l'occupation de l'appart chaque caractere represente une semaine 0 libre 1 occupe
    add_column :appartements, :occupationAnneePaire, :string ,  :default => '0000000000000000000000000000000000000000000000000000'
    add_column :appartements, :occupationAnneeImpaire, :string,  :default => '0000000000000000000000000000000000000000000000000000'
  end

  def self.down
    remove_column :appartements, :occupationAnneePaire
    remove_column :appartements, :occupationAnneeImpaire

  end
end
