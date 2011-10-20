class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.boolean :recentizer
      t.string :branch
      t.string  :folder_path

      t.timestamps
    end
  end
end
