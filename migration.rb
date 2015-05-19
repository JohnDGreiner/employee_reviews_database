require './departments_migration.rb'
require './employees_migration.rb'

DepartmentsMigration.migrate(:up)
EmployeesMigration.migrate(:up)
