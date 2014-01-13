=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class RenameRewardDefinitionToGoal < ActiveRecord::Migration
  def change
    rename_table :reward_definitions, :goals
    rename_column :routines, 'reward_definition_id', 'goal_id'
  #  rename_index :goals, 'index_reward_definitions_on_person_id', 'index_goals_on_person_id'
  end 
end
