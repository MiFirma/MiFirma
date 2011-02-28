class AddTermsToSignatures < ActiveRecord::Migration
  def self.up
    add_column :signatures, :terms, :boolean
  end

  def self.down
    remove_column :signatures, :terms
  end
end
