class CreateExpectations < ActiveRecord::Migration
  def change
    create_table :expectations do |t|
      t.string :description
      t.references :routine, index: true

      t.timestamps
    end
  end
end
