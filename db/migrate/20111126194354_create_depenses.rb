class CreateDepenses < ActiveRecord::Migration
  def self.up
    create_table :depenses do |t|
      t.integer :appartement_id
      t.date :date
      t.string :emetteur
      t.string :typeDepense
      t.string :soustype
      t.float :montant_total
      t.float :repartition ,:default=>1
      t.float :montant_reparti
      t.string :remarque

      t.timestamps
    end
  end

  def self.down
    drop_table :depenses
  end
end
