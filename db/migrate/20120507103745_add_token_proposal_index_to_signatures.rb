class AddTokenProposalIndexToSignatures < ActiveRecord::Migration
  def self.up
	add_index :signatures, :token
  end

  def self.down
	remove_index :signatures, :token
  end
end
