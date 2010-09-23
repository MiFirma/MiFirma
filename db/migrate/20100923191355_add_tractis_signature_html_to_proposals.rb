class AddTractisSignatureHtmlToProposals < ActiveRecord::Migration
  def self.up
    add_column :proposals, :tractis_signature_html, :text
  end

  def self.down
    remove_column :proposals, :tractis_signature_html
  end
end
