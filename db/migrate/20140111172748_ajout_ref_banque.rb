class AjoutRefBanque < ActiveRecord::Migration
  def self.up
    add_column :paiements, :date_banque, :date
    add_column :paiements, :ref_banque, :string
    add_column :factures, :date_banque, :date
    add_column :factures, :ref_banque, :string
  end

  def self.down
    remove_column :paiements, :date_banque
    remove_column :paiements, :ref_banque
    remove_column :factures, :date_banque
    remove_column :factures, :ref_banque
  end
end
