class CreateInvitations < ActiveRecord::Migration
  def change
    create_table 'invitations' do |t|
      t.integer 'issuer_id'
      t.integer 'project_id'
      t.string  'email'
      t.string  'role'
    end
  end
end
