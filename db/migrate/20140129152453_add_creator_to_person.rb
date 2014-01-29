class AddCreatorToPerson < ActiveRecord::Migration
  def change
    add_reference :people, :creator, index: true
  end
end
