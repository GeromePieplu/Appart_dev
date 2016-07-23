class CreateLoyers < ActiveRecord::Migration
  def self.up
    create_table :loyers do |t|
      t.column :date_debut, :date 
      t.column :etat, :integer #0 si réglé et 1 sinon
      t.column :client_id, :integer
      t.column :appartement_id, :integer
      t.column :montant_loyer_id, :integer
      t.column :montant_charge_id, :integer
    end
  end

  def self.down
    drop_table :loyers
  end
end
