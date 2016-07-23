class CreatePaiements < ActiveRecord::Migration
  def self.up
    create_table :paiements do |t|
      t.column :date_paiement, :date
      t.column :type_paiement, :string
      t.column :montant, :float
      t.column :numero_cheque, :string
      t.column :reservation_id, :integer 
    end
  end
  def self.down
    drop_table :paiements
  end
end
