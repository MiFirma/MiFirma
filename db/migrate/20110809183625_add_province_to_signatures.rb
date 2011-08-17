class AddProvinceToSignatures < ActiveRecord::Migration
  def self.up
    add_column :signatures, :province_id, :integer
    add_column :signatures, :municipality_id, :integer
  end

  def self.down
    remove_column :signatures, :municipality_id
    remove_column :signatures, :province_id
  end
end
