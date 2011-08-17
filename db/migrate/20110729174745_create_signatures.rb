class CreateSignatures < ActiveRecord::Migration
  def self.up
    create_table :signatures do |t|
      t.integer :proposal_id
      t.string :email
      t.integer :state
      t.string :token
      t.string :tractis_contract_location
      t.string :name
      t.string :dni
      t.string :surname
      t.boolean :terms

      t.timestamps
    end
  end

  def self.down
    drop_table :signatures
  end
end
