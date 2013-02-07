class AddAutonomicToProposals < ActiveRecord::Migration
  def self.up
    add_column :proposals, :subtype, :string
    add_column :proposals, :subtype_provinces, :string
  end

  def self.down
    remove_column :proposals, :subtype_provinces
    remove_column :proposals, :subtype
  end
end
