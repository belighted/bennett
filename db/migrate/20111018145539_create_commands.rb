class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.integer :project_id
      t.string :command
      t.integer :order

      t.timestamps
    end
  end
end
