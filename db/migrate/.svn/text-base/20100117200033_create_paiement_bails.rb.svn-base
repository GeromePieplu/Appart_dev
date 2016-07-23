class CreatePaiementBails < ActiveRecord::Migration
  def self.up
    create_table :paiement_bails do |t|
      t.date :date
      t.string :type
      t.float :montant
      t.string :provenance
      t.integer :numero_cheque
      t.integer :bail_id

      t.timestamps
    end
  end

  def self.down
    drop_table :paiement_bails
  end
end
