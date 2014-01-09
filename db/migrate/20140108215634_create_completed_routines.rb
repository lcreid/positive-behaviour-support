class CreateCompletedRoutines < ActiveRecord::Migration
  def change
    create_table :completed_routines do |t|
      t.string :name
      t.string :comment
      t.references :person, index: true
      t.references :routine, index: true

      t.timestamps
    end
  end
end
