class AddTractisSignatureToSignature < ActiveRecord::Migration
  def self.up
    add_column :signatures, :tractis_signature_file_name, :string
    add_column :signatures, :tractis_signature_content_type, :string
    add_column :signatures, :tractis_signature_file_size, :integer
    add_column :signatures, :tractis_signature_updated_at, :datetime
  end

  def self.down
    remove_column :signatures, :tractis_signature_updated_at
    remove_column :signatures, :tractis_signature_file_size
    remove_column :signatures, :tractis_signature_content_type
    remove_column :signatures, :tractis_signature_file_name
  end
end
