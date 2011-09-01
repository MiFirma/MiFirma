class AddHandwrittenSignaturesToProposals < ActiveRecord::Migration
  def self.up
    add_column :proposals, :handwritten_signatures, :integer
  end

  def self.down
    remove_column :proposals, :handwritten_signatures
  end
end
