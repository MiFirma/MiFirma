class AddAttrToSignatures < ActiveRecord::Migration
  def self.up
    add_column :signatures, :email, :string
    add_column :signatures, :state, :integer
    add_column :signatures, :token, :string
    add_column :signatures, :tractis_contract_location, :string
    add_column :signatures, :tractis_contract_code, :string
  end

  def self.down
    remove_column :signatures, :tractis_contract_code
    remove_column :signatures, :tractis_contract_location
    remove_column :signatures, :token
    remove_column :signatures, :state
    remove_column :signatures, :email
  end
end
