class Areas < ActiveRecord::Migration
  def self.up
    area_names = ["Marketing", "Programacion", "Legislacion", "Financiacion"]
    area_names.each do |name|
      Area.create!(:name => name)
    end
  end

  def self.down
  end
end
