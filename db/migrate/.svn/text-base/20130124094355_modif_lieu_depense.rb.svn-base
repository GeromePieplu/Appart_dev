class ModifLieuDepense < ActiveRecord::Migration
  def self.up
    remove_column :factures, :lieuDepense
    add_column :factures, :immeuble_id, :integer
  end

  def self.down
    remove_column :factures, :immeuble_id
    add_column :factures, :lieuDepense, :string
  end
end
