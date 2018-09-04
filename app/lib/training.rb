# frozen_string_literal: true

class Hash
  def change_keys(mappings)
    Hash[
      map do |k, v|
        [
          mappings[k] || k,
          if v.is_a?(Hash)
            v.change_keys(mappings)
          elsif v.is_a?(Array)
            v.collect { |x| x.is_a?(Hash) ? x.change_keys(mappings) : x }
          else
            v
          end
        ]
      end
    ]
  end

  def change_values(mappings)
    Hash[
      map do |k, v|
        [
          k,
          if v.is_a?(Hash)
            v.change_values(mappings)
          elsif v.is_a?(Array)
            v.collect { |x| x.is_a?(Hash) ? x.change_values(mappings) : mappings[k] || v }
          else
            mappings[k] || v
          end
        ]
      end
    ]
  end
end

module Training
  def self.create(user)
    # When a new user comes along, we create some training/demo data for them.
    # They get two patients. The first patient has three routines and two goals.
    # The first goal, rather unrealistically, requires only three clean routines
    # to be eligible for a reward.
    pt1 = {
      name: "Training Patient 1",
      creator_id: user.id,
      created_at: user.created_at, # So we can easily delete the training data.
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

    pt = user.subjects.create!(pt1)
    # Patch the first two routines to have the goals associated with them
    pt.routines[0..1].each { |r| pt.goals[0].routines << r }
    # The first patient also has ten completed routines, eight of which are clean,
    # meaning the patient is eligible for two rewards, with two left over.
    [6, 4, 3].each_with_index do |reps, i|
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

    # The second patient has two routines and no goals.
    pt2 = {
      name: "Training Patient 2",
      creator_id: user.id,
      created_at: user.created_at, # So we can easily delete the training data.
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

    pt = user.subjects.create!(pt2)

    user.primary_identity.linkup(User.create!(name: "Training User 1", uid: 1, provider: "Training", created_at: user.created_at))
  end

  def self.make_completed_routines(routine, reps, date_increment, start_time = Time.current)
    completed_routines = []
    reps.times do |i|
      completed_routines << CompletedRoutine.create!(routine.copyable_attributes) do |cr|
        #        puts "routine.copyable_attributes: #{routine.copyable_attributes.inspect}"
        cr.created_at = cr.updated_at = start_time + i * date_increment
        cr.completed_expectations.each do |ce|
          ce.save!
          #          puts "ce: #{ce.inspect}"
          ce.comment = "Comment #{i}"
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

  # rdoc
  # Delete the training data for a user, defined as patients and user
  # created within 15s of the user being created.
  def self.delete(user)
    # Assumes delete dependent is on for the relevant associations.
    range = user.created_at - 1.second..user.created_at + 15.seconds

    user.users.each do |u|
      if range.cover? u.created_at
        user.unlink(u)
        u.destroy
      end
    end

    user.subjects.reload.each do |p|
      if range.cover? p.created_at
        # user.unlink(p)
        p.destroy
      end
    end
  end
end
