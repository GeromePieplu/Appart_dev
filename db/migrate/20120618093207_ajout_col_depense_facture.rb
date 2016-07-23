class AjoutColDepenseFacture < ActiveRecord::Migration
  def self.up
    add_column :depenses, :typeDepense, :string
    add_column :factures, :lieuDepense, :string
  end

  def self.down
    remove_column :depenses, :typeDepense
    remove_column :factures, :lieuDepense
  end
end
