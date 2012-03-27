class AddIlpCodeToProposals < ActiveRecord::Migration
  def self.up
    add_column :proposals, :ilp_code, :string
  end

  def self.down
    remove_column :proposals, :ilp_code
  end
end
