class AjoutCaution < ActiveRecord::Migration
  def self.up
        add_column :appartements, :montant_caution,:float
        add_column :appartements, :type_location , :string,  :default => "Semaine"
  end

  def self.down
        remove_column :appartements, :montant_caution
        remove_column :appartements, :type_location
  end
end
