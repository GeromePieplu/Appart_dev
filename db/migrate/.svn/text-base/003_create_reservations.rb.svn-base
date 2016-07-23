class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.column :prix, :float
      t.column :date_ouverture, :date
      t.column :date_debut, :date
      t.column :date_fin, :date
      t.column :etat, :string
      t.column :nombre_personne, :integer
      t.column :acompte, :float
      t.column :client_id, :integer
      t.column :appartement_id, :integer
    end
  end

  def self.down
    drop_table :reservations
  end
end
