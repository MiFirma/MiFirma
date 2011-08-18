class AddIndexStatusAndDniFromSignatures < ActiveRecord::Migration
  def self.up
		add_index :signatures, [:proposal_id, :state]
		add_index :signatures, :dni
  end

  def self.down
		remove_index :signatures, [:proposal_id, :state]
		remove_index :signatures, :dni
  end
end
