class CreateEndorsmentProposals < ActiveRecord::Migration
  def self.up
    create_table :endorsment_proposals do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :endorsment_proposals
  end
end
