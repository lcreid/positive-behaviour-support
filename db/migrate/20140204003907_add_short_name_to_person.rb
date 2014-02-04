class AddShortNameToPerson < ActiveRecord::Migration
  def change
    add_column :people, :short_name, :string
  end
end
