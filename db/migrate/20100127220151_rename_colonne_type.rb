class RenameColonneType < ActiveRecord::Migration
  def self.up
    rename_column :paiement_bails, :type, :type_paiement
  end

  def self.down
    rename_column :paiement_bails , :type_paiement, :type
  end
end
