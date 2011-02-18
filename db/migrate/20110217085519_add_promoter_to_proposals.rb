class AddPromoterToProposals < ActiveRecord::Migration
  def self.up
    add_column :proposals, :promoter_name, :string
    add_column :proposals, :promoter_url, :string
  end

  def self.down
    remove_column :proposals, :promoter_url
    remove_column :proposals, :promoter_name
  end
end
