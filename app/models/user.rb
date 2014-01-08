require 'person_helper'

class User < ActiveRecord::Base
  has_many :identities, class_name: "Person"
  has_many :links, through: :identities
  has_many :people, through: :links, :source => :person_b
  
  after_create :add_primary_identity
  
  include PersonHelper

=begin rdoc
Find the user based on the information provided by Omniauth,
or create a User based on the information provided by Omniauth if
it doesn't exist.
=end
  def self.from_omniauth_or_create(auth)
    from_omniauth(auth) || create_from_omniauth(auth)
  end
  
=begin rdoc
Find the user based on the information provided by Omniauth.
=end
  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first
  end

=begin rdoc
Return true if the user already exists, based on the information
provided by Omniauth, false otherwise.
=end
  def self.from_omniauth_exists?(auth)
    from_omniauth(auth)? true: false
  end

=begin rdoc
Create a User based on the information provided by Omniauth.
=end
  def self.create_from_omniauth(auth)
    user = create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
  end

=begin rdoc
Return the Person that is the primary identity of the user.
=end
  def primary_identity
    identities.first
  end
#  
#  def name
#    "#{self.class}: #{super}"
#  end

  private
    
=begin rdoc
After create callback to add the primary identity of the user.
=end
  def add_primary_identity
    (identities << Person.create!(name: name)).first
  end
end
