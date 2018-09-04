class CreatePersonUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :person_users do |t|
      t.references :person, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
