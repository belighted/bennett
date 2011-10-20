class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :source
      t.boolean :recentizer

      t.timestamps
    end
  end
end
