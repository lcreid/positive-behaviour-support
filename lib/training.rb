=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class Hash  
  def change_keys(mappings)
    Hash[
      map { |k, v| 
        [ 
        mappings[k] || k,  
        case
          when v.kind_of?(Hash)
            v.change_keys(mappings)
          when v.kind_of?(Array)
            v.collect { |x| x.kind_of?(Hash) ? x.change_keys(mappings): x }
          else 
            v
        end
        ] 
      }
    ]
  end
  
  def change_values(mappings)
    Hash[
      map { |k, v| 
        [ 
        k,
        case
          when v.kind_of?(Hash)
            v.change_values(mappings)
          when v.kind_of?(Array)
            v.collect { |x| x.kind_of?(Hash) ? x.change_values(mappings): mappings[k] || v}
          else 
            mappings[k] || v
        end
        ] 
      }
    ]
  end
end

module Training
  def Training.create(user)
=begin
When a new user comes along, we create some training/demo data for them.
=end
    i = user.primary_identity
=begin
They get two patients. The first patient has three routines and two goals.
The first goal, rather unrealistically, requires only three clean routines
to be eligible for a reward.
=end
    pt1 = {
      name: "Training Patient 1", 
      creator_id: user.id,
      routines_attributes: [
        {
          name: "Clean up room", 
          expectations_attributes: [
            { description: "Do without reminder" }
          ]
        },
        {
          name: "Brush teeth",
          expectations_attributes: [
            { description: "Use the right toothbrush" }
          ]
        },
        {
          name: "Do homework",
          expectations_attributes: [
            { description: "Get pencils, pens, etc." },
            { description: "Put away pencils, pens, etc." }
          ]
        }
      ],
      goals_attributes: [
        { name: "Time Off", description: "Training Patient 1 gets to skip a session.", target: 3 },
        { name: "Goal 2", description: "Not assigned yet.", target: 2 }
      ]
    }
    
    pt = Person.create!(pt1)
    # Patch the first two routines to have the goals associated with them
    pt.routines[0..1].each { |r| pt.goals[0].routines << r }
=begin
The first patient also has ten completed routines, eight of which are clean,
meaning the patient is eligible for two rewards, with two left over.
=end
    [6,4,3].each_with_index do |reps,i|
      make_completed_routines(pt.routines[i], reps, -1.day)
    end
    # Make two of the routines not clean.
    pt.routines[0].completed_routines[2].completed_expectations[0].observation = "N"
    pt.routines[1].completed_routines[1].completed_expectations[0].observation = "N"
    pt.routines[0].completed_routines[2].completed_expectations[0].save!
    pt.routines[1].completed_routines[1].completed_expectations[0].save!
#    clean_up_room = pt1[:routines_attributes][0].merge(routine_id: pt.routines[0].id)
#    pt.routines[0] << CompletedRoutine.create!(pt1[:routines_attributes])
#    brush_teeth = pt1[:routines_attributes][1].merge(routine_id: pt.routines[1].id)
    
    i.linkup(pt)
=begin
The second patient has two routines and no goals.
=end
    pt2 = {
      name: "Training Patient 2",
      creator_id: user.id,
      routines_attributes: [
        {
          name: "Turn off Minecraft",
          expectations_attributes: [
            { description: "Turn off game at nine without being asked" },
            { description: "Don't ask for more time" }
          ]
        },
        {
          name: "Go to bed",
          expectations_attributes: [
            { description: "Put on pyjamas" },
            { description: "Set alarm" },
            { description: "Read for ten minutes" }
          ]
        }
      ]
    }
    
    pt = Person.create!(pt2)
    i.linkup(pt)
    
    i.linkup(User.create!(name: "Training User 1", uid: 1, provider: "Training"))
  end
  
  def Training.make_completed_routines(routine, reps, date_increment, start_time = Time.current)
    completed_routines = []
    reps.times do |i|
      completed_routines << CompletedRoutine.create!(routine.copyable_attributes) do |cr|
#        puts "routine.copyable_attributes: #{routine.copyable_attributes.inspect}"
        cr.created_at = cr.updated_at = start_time + i * date_increment
        cr.completed_expectations.each do |ce|
          ce.save!
#          puts "ce: #{ce.inspect}"
          ce.comment = "Comment #{i.to_s}"
          ce.observation = "Y"
        end
      end
#      hash = routine.attributes.change_keys("id" => "routine_id" ).
#        merge("created_at" => start_time + i * date_increment, 
#          "updated_at" => start_time + i * date_increment
#        )
#      hash.delete_if { |k,v| k == "goal_id" }
#      hash = hash.merge(completed_expectations_attributes: 
#        routine.expectations.collect do |e| 
#          e.attributes.
#            merge("observation" => "Y", 
#              "comment" => "Comment #{i.to_s}",
#              "created_at" => start_time + i * date_increment, 
#              "updated_at" => start_time + i * date_increment
#              ).
#            delete_if { |k,v| k == "routine_id" || k == "id" } 
#        end
#      )
#      completed_routines << hash
    end
    completed_routines
  end
end



