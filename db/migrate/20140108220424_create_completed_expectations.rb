=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class CreateCompletedExpectations < ActiveRecord::Migration
  def change
    create_table :completed_expectations do |t|
      t.string :description
      t.string :observation
      t.string :comment
      t.references :completed_routine, index: true

      t.timestamps
    end
  end
end
