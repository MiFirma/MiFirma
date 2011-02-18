class AddNumRequiredSignaturesToProposals < ActiveRecord::Migration
  def self.up
    add_column :proposals, :num_required_signatures, :integer
  end

  def self.down
    remove_column :proposals, :num_required_signatures
  end
end
