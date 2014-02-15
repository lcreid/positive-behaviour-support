require_relative '20140214224832_add_category_to_completed_routine'

class RemoveCategoryFromCompletedRoutine < ActiveRecord::Migration
  def change
    revert AddCategoryToCompletedRoutine
  end
end
