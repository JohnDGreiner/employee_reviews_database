require './departments_migration.rb'
require './employees_migration.rb'
require './emails_migration.rb'

DepartmentsMigration.migrate(:up)
EmployeesMigration.migrate(:up)
EmailsMigration.migrate(:up)
