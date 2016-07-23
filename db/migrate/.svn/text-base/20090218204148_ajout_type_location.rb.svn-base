class AjoutTypeLocation < ActiveRecord::Migration
  def self.up
        add_column :reservations, :type_location , :string,  :default => "Semaine_1_paiement"
        add_column :reservations, :montant_total , :float        
  end

  def self.down
        remove_column :reservations, :type_location
        remove_column :reservations, :montant_total
  end

end
