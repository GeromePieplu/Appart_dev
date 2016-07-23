class CreateMontantLoyers < ActiveRecord::Migration
  def self.up
    create_table :montant_loyers do |t|
      t.column :date_debut, :date
      t.column :date_fin, :date
      t.column :montant, :float
      t.column :appartement_id, :integer
    end
  end
  
  def self.down
    drop_table :montant_loyers
  end
end
