class CreateSignatures < ActiveRecord::Migration
  def self.up
    create_table :signatures do |t|
      t.integer :proposal_id

      t.timestamps
    end
  end

  def self.down
    drop_table :signatures
  end
end
