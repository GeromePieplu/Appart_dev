class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :nom
      t.string :prenom
      t.text :adresse
      t.integer :code_postal
      t.string :ville
      t.string :telephone
      t.string :email
    end
  end

  def self.down
    drop_table :clients
  end
end
