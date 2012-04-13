class AddTelephoneToSignatures < ActiveRecord::Migration
  def self.up
    add_column :signatures, :telephone, :string
  end

  def self.down
    remove_column :signatures, :telephone
  end
end
