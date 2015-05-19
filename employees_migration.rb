require './migration_require.rb'

class EmployeesMigration < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :phone_number
      t.decimal :salary, precision: 2, scale: 9
      t.boolean :satisfactory
      t.references :department
      t.timestamps null: false
    end
  end
end
