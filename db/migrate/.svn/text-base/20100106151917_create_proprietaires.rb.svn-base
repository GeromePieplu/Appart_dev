class CreateProprietaires < ActiveRecord::Migration
  def self.up
    create_table :proprietaires do |t|
      t.string :nom
      t.string :prenom
      t.text :adresse
      t.string :code_postal
      t.string :ville
      t.string :telephone
      t.string :email
      t.string :pays, :default => 'France' 

      t.timestamps
    end
  end

  def self.down
    drop_table :proprietaires
  end
end
