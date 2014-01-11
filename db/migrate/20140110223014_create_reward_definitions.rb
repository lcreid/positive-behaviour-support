class CreateRewardDefinitions < ActiveRecord::Migration
  def change
    create_table :reward_definitions do |t|
      t.string :name
      t.string :description
      t.integer :target
      t.references :person, index: true

      t.timestamps
    end
  end
end
