class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :build_id
      t.integer :command_id
      t.text :log
      t.string :status_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
