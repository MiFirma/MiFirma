class AddUnsubscribeToSignatures < ActiveRecord::Migration
  def self.up
    add_column :signatures, :unsubscribe, :boolean
  end

  def self.down
    remove_column :signatures, :unsubscribe
  end
end
