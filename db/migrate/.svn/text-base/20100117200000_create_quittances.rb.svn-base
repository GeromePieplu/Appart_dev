class CreateQuittances < ActiveRecord::Migration
  def self.up
    create_table :quittances do |t|
      t.integer :numero
      t.date :mois
      t.integer :montant_loyer_id
      t.integer :montant_charge_id
      t.integer :bail_id

      t.timestamps
    end
  end

  def self.down
    drop_table :quittances
  end
end
