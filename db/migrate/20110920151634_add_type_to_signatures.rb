class AddTypeToSignatures < ActiveRecord::Migration
  def self.up
    add_column :signatures, :type, :string
  end

  def self.down
    remove_column :signatures, :type
  end
end
