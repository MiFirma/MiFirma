class AddSurname2ToSignatures < ActiveRecord::Migration
  def self.up
    add_column :signatures, :surname2, :string
  end

  def self.down
    remove_column :signatures, :surname2
  end
end
