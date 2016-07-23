class AjoutCommentairePaiements < ActiveRecord::Migration
  def self.up
        add_column :paiements, :commentaires , :string
        add_column :paiement_bails, :commentaires , :string
  end

  def self.down
        remove_column :paiements, :commentaires
        remove_column :paiement_bails, :commentaires
  end
end
