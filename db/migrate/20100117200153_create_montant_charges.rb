class CreateMontantCharges < ActiveRecord::Migration
  def self.up
    create_table :montant_charges do |t|
      t.date :date_debut
      t.float :montant
      t.integer :bail_id

      t.timestamps
    end
  end

  def self.down
    drop_table :montant_charges
  end
end
