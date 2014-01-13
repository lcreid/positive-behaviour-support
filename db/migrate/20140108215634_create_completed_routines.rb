=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class CreateCompletedRoutines < ActiveRecord::Migration
  def change
    create_table :completed_routines do |t|
      t.string :name
      t.string :comment
      t.references :person, index: true
      t.references :routine, index: true

      t.timestamps
    end
  end
end
