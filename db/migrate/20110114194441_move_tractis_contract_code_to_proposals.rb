class MoveTractisContractCodeToProposals < ActiveRecord::Migration
  def self.up
    remove_column :signatures, :tractis_contract_code
    add_column :proposals, :tractis_contract_code, :string
  end

  def self.down
    add_column :signatures, :tractis_contract_code, :string
    remove_column :proposals, :tractis_contract_code
  end
end
