class CreateEndorsmentSignatures < ActiveRecord::Migration
  def self.up
    create_table :endorsment_signatures do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :endorsment_signatures
  end
end
