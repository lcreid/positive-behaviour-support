class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :invitor, index: true
      t.string :e_mail
      t.string :token
      t.string :disposition

      t.timestamps
    end
  end
end
