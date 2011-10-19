class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.integer :project_id
      t.string :commit_hash
      t.string :commit_message
      t.string :commit_author
      t.datetime :commit_date

      t.timestamps
    end
  end
end
