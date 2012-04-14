class AddNumberOfSheetsToSignature < ActiveRecord::Migration
  def self.up
    add_column :signatures, :number_of_sheets, :integer
  end

  def self.down
    remove_column :signatures, :number_of_sheets
  end
end
