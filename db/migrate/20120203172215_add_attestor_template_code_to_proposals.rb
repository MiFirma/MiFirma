class AddAttestorTemplateCodeToProposals < ActiveRecord::Migration
  def self.up
    add_column :proposals, :attestor_template_code, :string
  end

  def self.down
    remove_column :proposals, :attestor_template_code
  end
end
