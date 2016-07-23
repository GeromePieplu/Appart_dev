class ModificationCalculSolde < ActiveRecord::Migration
  def self.up
    add_column :bails, :apayer_depuis_solde , :float
    add_column :bails, :date_maj_apayer , :date     
    add_column :montant_loyers, :date_fin , :date
    add_column :montant_charges, :date_fin , :date
  end

  def self.down
    remove_column :bails, :apayer_depuis_solde 
    remove_column :bails, :date_maj_apayer     
    remove_column :montant_loyers, :date_fin
    remove_column :montant_charges, :date_fin
  end
end
