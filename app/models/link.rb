class Link < ActiveRecord::Base
  belongs_to :person_a, class_name: "Person"
  belongs_to :person_b, class_name: "Person"
end
