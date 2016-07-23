class AjoutFacturesmodificationdepenses < ActiveRecord::Migration
  def self.up
      create_table :factures do |t|
      t.date :date
      t.string :emetteur
      t.string :typeDepense
      t.string :soustype
      t.float :montant
      t.string :remarque

      t.timestamps
    end
      remove_column :depenses, :date
      add_column    :depenses, :facture_id, :integer
      remove_column :depenses, :emetteur
      remove_column :depenses, :typeDepense
      remove_column :depenses, :soustype
      remove_column :depenses, :montant_total
  end

  def self.down
      drop_table :factures
      add_column :depenses, :date, :date
      remove_column    :depenses, :facture_id
      add_column :depenses, :emetteur, :string
      add_column :depenses, :typeDepense, :string
      add_column :depenses, :soustype, :string
      add_column :depenses, :montant_total, :float
  end
end
