class AddBuildOnceFlagToProject < ActiveRecord::Migration
  def change
    add_column :projects, :build_nightly, :boolean, :default => false
  end
end
