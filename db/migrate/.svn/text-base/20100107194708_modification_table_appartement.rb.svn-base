class ModificationTableAppartement < ActiveRecord::Migration
  def self.up
    remove_column :appartements, :nom_proprietaire
    remove_column :appartements, :prenom_proprietaire
    add_column :appartements, :proprietaire_id, :integer
    add_column :appartements, :gerant_id, :integer    
    change_column :appartements, :type_location, :string , :default=> "Meublé"
  end

  def self.down
    add_column :appartements, :nom_proprietaire, :string
    add_column :appartements, :prenom_proprietaire, :string
    remove_column :appartements, :proprietaire_id
    remove_column :appartements, :gerant_id

  end
end
