class AjoutSolde < ActiveRecord::Migration
  def self.up
    add_column :bails, :solde , :float
    add_column :bails, :date_solde , :date    
  end

  def self.down
    remove_column :bails, :solde
    remove_column :bails, :date_solde
  end
end
