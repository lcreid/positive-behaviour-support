module Training
  def Training.create(user)
    i = user.primary_identity
    pt = Person.create!(name: "Training Patient 2")
    pt.routines << Routine.create!(name: "Clean up room", 
      expectations_attributes: [
        {
          description: "Do without reminder"
        }
      ])
    pt.routines << Routine.create!(name: "Brush teeth",
      expectations_attributes: [
        {
          description: "Use the right toothbrush"
        }
      ])
    pt.routines << Routine.create!(name: "Do homework",
      expectations_attributes: [
        {
          description: "Get pencils, pens, etc."
        },
        {
          description: "Put away pencils, pens, etc."
        }
      ])
    i.people << pt
    
    pt = Person.create!(name: "Training Patient 2")
    pt.routines << Routine.create!(name: "Turn off Minecraft",
      expectations_attributes: [
        {
          description: "Turn off game at nine without being asked"
        },
        {
          description: "Don't ask for more time"
        }
      ])
    pt.routines << Routine.create!(name: "Go to bed",
      expectations_attributes: [
        {
          description: "Put on pyjamas"
        },
        {
          description: "Set alarm"
        },
        {
          description: "Read for ten minutes"
        }
      ])
    i.people << pt
    
    i.people << User.create!(name: "Training User 1", uid: 1, provider: "Training").primary_identity
  end
end



