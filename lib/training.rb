module Training
  def Training.create(user)
    i = user.primary_identity
    pt = Person.create!(name: "1 Training Patient")
    pt.routines << Routine.create!(name: "Clean up room")
    pt.routines << Routine.create!(name: "Brush teeth")
    pt.routines << Routine.create!(name: "Do homework")
    i.people << pt
    
    pt = Person.create!(name: "2 Training Patient")
    pt.routines << Routine.create!(name: "Turn off Minecraft")
    pt.routines << Routine.create!(name: "Go to bed")
    i.people << pt
    
    i.people << User.create!(name: "1 Training User", uid: 1, provider: "Training").primary_identity
  end
end
