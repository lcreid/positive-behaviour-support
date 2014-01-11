class RenameRewardDefinitionToGoal < ActiveRecord::Migration
  def change
    rename_table :reward_definitions, :goals
    rename_column :routines, 'reward_definition_id', 'goal_id'
  #  rename_index :goals, 'index_reward_definitions_on_person_id', 'index_goals_on_person_id'
  end 
end
