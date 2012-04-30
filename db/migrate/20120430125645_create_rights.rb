class CreateRights < ActiveRecord::Migration
  def change
    create_table 'rights' do |t|
      t.integer 'project_id', :null => false
      t.integer 'user_id',    :null => false
      t.string  'role',       :null => false
    end
  end
end
