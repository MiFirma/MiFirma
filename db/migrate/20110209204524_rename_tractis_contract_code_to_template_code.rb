class RenameTractisContractCodeToTemplateCode < ActiveRecord::Migration
  def self.up
    rename_column :proposals, :tractis_contract_code, :tractis_template_code
  end

  def self.down
    rename_column :proposals, :tractis_template_code, :tractis_contract_code
  end
end