class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :to, index: true
      t.references :from, index: true
      t.boolean :read, default: false
      t.string :message_type
      t.boolean :reported_as_spam, default: false
      t.string :recipient_action
      t.string :body

      t.timestamps
    end
  end
end
