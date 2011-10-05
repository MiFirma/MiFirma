class RenameProblemsToProposal < ActiveRecord::Migration
  def self.up
		remove_column :proposals, :problem
		add_column :proposals, :problem, :text
  end

  def self.down
		remove_column :proposals, :problem
		add_column :proposals, :problem, :string
  end
end
