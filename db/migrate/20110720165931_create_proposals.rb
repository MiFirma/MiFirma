class CreateProposals < ActiveRecord::Migration
  def self.up
    create_table :proposals do |t|
      t.string :name
      t.string :problem
      t.string :howto_solve
      t.integer :position
      t.string :tractis_template_code
      t.string :pdf_file_name
      t.string :pdf_content_type
      t.integer :pdf_file_size
      t.datetime :pdf_updated_at
      t.integer :num_required_signatures
      t.string :promoter_name
      t.string :promoter_url

      t.timestamps
    end
  end

  def self.down
    drop_table :proposals
  end
end
