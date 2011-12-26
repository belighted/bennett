class AddEmailOnBuilds < ActiveRecord::Migration
  def up
    add_column :builds, :commit_author_email, :string
  end

  def down
    remove_column :builds, :commit_author_email
  end
end