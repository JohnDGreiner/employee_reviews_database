require './migration_require.rb'

class EmailsMigration < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :email_address
      t.references :employee
      t.timestamps null: false
    end
  end
end
