class AddElectionTypeToProposals < ActiveRecord::Migration
  def self.up
    add_column :proposals, :election_type, :string
  end

  def self.down
    remove_column :proposals, :election_type
  end
end
