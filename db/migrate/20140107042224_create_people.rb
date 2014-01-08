class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.references :user, index: true
      t.string :name

      t.timestamps
    end
  end
end
