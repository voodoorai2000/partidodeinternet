class MoreFieldForUser < ActiveRecord::Migration
  def self.up
    add_column :users, :url, :string
    add_column :users, :region_id, :integer
  end

  def self.down
    remove_column :users, :region_id
    remove_column :users, :url
  end
end
