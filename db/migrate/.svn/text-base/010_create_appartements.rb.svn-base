class CreateAppartements < ActiveRecord::Migration
  def self.up
    create_table :appartements do |t|
      t.string :nom
      t.string :nom_proprietaire
      t.string :prenom_proprietaire
      t.text :adresse
      t.integer :code_postal
      t.string :ville
      t.float :superficie
    end
  end

  def self.down
    drop_table :appartements
  end
end
