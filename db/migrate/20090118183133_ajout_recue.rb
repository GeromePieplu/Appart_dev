class AjoutRecue < ActiveRecord::Migration
 def self.up
    create_table :recues do |t|
      t.column :date_recue, :date
      t.column :montant, :float
      t.column :reservation_id, :integer 
    end
  end
  def self.down
    drop_table :recues
  end
end
