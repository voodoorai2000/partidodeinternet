class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.string   :from, :to, :cc
      t.text     :mail

      t.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end
