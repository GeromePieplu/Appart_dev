class CreateMontantLoyers < ActiveRecord::Migration
  def self.up
    create_table :montant_loyers do |t|
      t.date :date_debut
      t.float :montant
      t.integer :bail_id

      t.timestamps
    end
  end

  def self.down
    drop_table :montant_loyers
  end
end
