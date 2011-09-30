class RenameHowToToProposals < ActiveRecord::Migration
  def self.up
		remove_column :proposals, :howto_solve
		add_column :proposals, :howto_solve, :text
  end

  def self.down
		remove_column :proposals, :howto_solve
		add_column :proposals, :howto_solve, :string
  end
end
