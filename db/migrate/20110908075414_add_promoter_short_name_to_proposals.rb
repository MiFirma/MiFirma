class AddPromoterShortNameToProposals < ActiveRecord::Migration
  def self.up
		add_column :proposals, :promoter_short_name, :string
  end

  def self.down
	  remove_column :proposals, :promoter_short_name
  end
end
