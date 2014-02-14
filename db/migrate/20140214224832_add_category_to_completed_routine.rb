class AddCategoryToCompletedRoutine < ActiveRecord::Migration
  def change
    add_column :completed_routines, :category, :string
  end
end
