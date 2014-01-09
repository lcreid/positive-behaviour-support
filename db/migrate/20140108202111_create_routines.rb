class CreateRoutines < ActiveRecord::Migration
  def change
    create_table :routines do |t|
      t.string :name
      t.references :person, index: true

      t.timestamps
    end
  end
end
