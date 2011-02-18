class AddNameAndDniToSignatures < ActiveRecord::Migration
  def self.up
    add_column :signatures, :name, :string
    add_column :signatures, :dni, :string
  end

  def self.down
    remove_column :signatures, :dni
    remove_column :signatures, :name
  end
end
