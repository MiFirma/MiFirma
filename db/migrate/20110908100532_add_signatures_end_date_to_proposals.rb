class AddSignaturesEndDateToProposals < ActiveRecord::Migration
  def self.up
    add_column :proposals, :signatures_end_date, :date
  end

  def self.down
    remove_column :proposals, :signatures_end_date
  end
end
