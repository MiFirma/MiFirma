class CreateElections < ActiveRecord::Migration
  def self.up
    create_table :elections do |t|
      t.string :name
      t.date :signatures_end_date

      t.timestamps
    end
		
		add_column :proposals, :election_id, :integer
		execute "INSERT INTO ELECTIONS (id, name, signatures_end_date) VALUES (1,'Generales 20N','2011-11-16')"
		execute "UPDATE proposals SET election_id=1"
  end

  def self.down
    drop_table :elections
		
		add_column :proposals, :election_id
  end
		
end
