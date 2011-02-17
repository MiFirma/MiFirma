class AddSurnameToSignatures < ActiveRecord::Migration
  def self.up
    add_column :signatures, :surname, :string
  end

  def self.down
    remove_column :signatures, :surname
  end
end
