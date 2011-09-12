class AddCensusFieldsToSignatures < ActiveRecord::Migration
  def self.up
    add_column :signatures, :address, :string
    add_column :signatures, :zipcode, :string
    add_column :signatures, :date_of_birth, :date
    add_column :signatures, :province_of_birth_id, :integer
    add_column :signatures, :municipality_of_birth_id, :integer
  end

  def self.down
    remove_column :signatures, :municipality_of_birth_id
    remove_column :signatures, :province_of_birth_id
    remove_column :signatures, :date_of_birth
    remove_column :signatures, :zipcode
    remove_column :signatures, :address
  end
end
