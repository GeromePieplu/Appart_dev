class AjoutSignatureEtUsers < ActiveRecord::Migration
  def self.up
    add_column :proprietaires, :signature , :string
    add_column :proprietaires, :login_name, :string, :default => 'nologin'
  end

  def self.down
    remove_column :proprietaires, :signature_path
    remove_column :proprietaires, :login_name
  end
end
