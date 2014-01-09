class CreateCompletedExpectations < ActiveRecord::Migration
  def change
    create_table :completed_expectations do |t|
      t.string :description
      t.string :observation
      t.string :comment
      t.references :completed_routine, index: true

      t.timestamps
    end
  end
end
