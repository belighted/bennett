class AddBuildOnceFlagToProject < ActiveRecord::Migration
  def change
    add_column :projects, :build_at_midnight, :boolean, :default => false
    add_index :projects, :build_at_midnight
  end
end
