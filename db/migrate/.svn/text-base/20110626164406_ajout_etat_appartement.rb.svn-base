class AjoutEtatAppartement < ActiveRecord::Migration
  def self.up
    add_column :appartements, :etat , :string,  :default => "en_location"
  end

  def self.down
    remove_column :appartements, :etat 
  end
end
