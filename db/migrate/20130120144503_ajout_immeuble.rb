class AjoutImmeuble < ActiveRecord::Migration
  def self.up
    add_column :appartements, :immeuble_id , :integer
  end

  def self.down
    remove_column :appartements, :immeuble_id 
  end
end
