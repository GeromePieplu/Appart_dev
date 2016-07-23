class CreateBails < ActiveRecord::Migration
  def self.up
    create_table :bails do |t|
      t.date :date_debut
      t.date :date_fin
      t.integer :etat
      t.integer :caution
      t.float :indice_reference
      t.integer :locataire_id
      t.integer :appartement_id
      t.integer :montant_loyer_id
      t.integer :montant_charge_id
      t.integer :quittance_id

      t.timestamps
    end
  end

  def self.down
    drop_table :bails
  end
end
