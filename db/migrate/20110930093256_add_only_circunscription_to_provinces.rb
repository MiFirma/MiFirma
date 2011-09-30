class AddOnlyCircunscriptionToProvinces < ActiveRecord::Migration
  def self.up
    add_column :provinces, :only_circunscription, :boolean
  end

  def self.down
    remove_column :provinces, :only_circunscription
  end
end
