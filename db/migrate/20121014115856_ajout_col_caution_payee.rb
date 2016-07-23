class AjoutColCautionPayee < ActiveRecord::Migration
  def self.up
    add_column :reservations, :cautionPaye, :string,  :default => "non payée" 
  end

  def self.down
    remove_column :reservations, :cautionPaye
  end
end
