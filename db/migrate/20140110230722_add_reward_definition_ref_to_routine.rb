class AddRewardDefinitionRefToRoutine < ActiveRecord::Migration
  def change
    add_reference :routines, :reward_definition, index: true
  end
end
