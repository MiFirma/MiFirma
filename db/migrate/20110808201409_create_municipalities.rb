class CreateMunicipalities < ActiveRecord::Migration
  def self.up
    create_table :municipalities  do |t|
			t.integer :id_ine
      t.string :name
      t.references :province

      t.timestamps
    end
		add_index :municipalities, :province_id

  end

  def self.down
    drop_table :municipalities
  end
end
