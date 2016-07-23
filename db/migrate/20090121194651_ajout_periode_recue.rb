class AjoutPeriodeRecue < ActiveRecord::Migration
  def self.up
     add_column :recues, :date_debut, :date
     add_column :recues, :date_fin, :date
  end

  def self.down
     remove_column :recues, :date_debut, :date
     remove_column :recues, :date_fin, :date
  end
end
