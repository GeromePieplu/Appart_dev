class AjoutPays < ActiveRecord::Migration
  def self.up
    add_column :clients, :pays, :string, :default => 'France'
  end

  def self.down
    remove_column :clients, :pays
  end
end
