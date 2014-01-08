class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :person_a, index: true
      t.references :person_b, index: true
      t.string :b_is

      t.timestamps
    end
  end
end
