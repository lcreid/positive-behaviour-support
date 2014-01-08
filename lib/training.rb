module Training
  def Training.create(user)
    [ "1 Training Patient", "2 Training Patient" ].each do |n|
      user.primary_identity.people << Person.create!(name: n)
    end
    
    [ "1 Training User" ].each_with_index do |n, i|
      u = User.create!(name: n, uid: i, provider: "Training")
      user.primary_identity.people << u.primary_identity
    end
  end
end
