class AddTypeToProposals < ActiveRecord::Migration
  def self.up
    add_column :proposals, :type, :string
  end

  def self.down
    remove_column :proposals, :type
  end
end
