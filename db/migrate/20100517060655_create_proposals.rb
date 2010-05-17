class CreateProposals < ActiveRecord::Migration
  def self.up
    create_table :proposals do |t|
      t.text :problem
      t.text :howto_solve
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :proposals
  end
end
