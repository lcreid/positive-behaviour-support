class RoutineCategory < ActiveRecord::Migration
  def change
    create_table :routine_categories do |t|
      t.references :person, index: true
      t.string :name

      t.timestamps
    end
  end
end
