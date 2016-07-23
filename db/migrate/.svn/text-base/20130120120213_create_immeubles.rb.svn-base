class CreateImmeubles < ActiveRecord::Migration
  def self.up
    create_table :immeubles do |t|
      t.string :nom
      t.text :adresse
      t.integer :code_postal
      t.string :ville
      t.date :date_achat

      t.timestamps
    end
  end

  def self.down
    drop_table :immeubles
  end
end
