class CreateMontantCharges < ActiveRecord::Migration
  def self.up
    create_table :montant_charges do |t|
      t.column :date_debut, :date
      t.column :date_fin, :date
      t.column :montant, :float
      t.column :appartement_id, :integer
    end
  end

  def self.down
    drop_table :montant_charges
  end
end
