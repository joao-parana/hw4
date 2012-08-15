class AddColumnDirector < ActiveRecord::Migration
  def up
    # add column director on table movies - type is String
    add_column :movies, :director, :string
  end

  def down
    # remove column director from table movies
    remove_column :movies, :director
  end
end
