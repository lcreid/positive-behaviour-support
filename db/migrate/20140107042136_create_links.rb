=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :person_a, index: true
      t.references :person_b, index: true
      t.string :b_is

      t.timestamps
    end
  end
end
