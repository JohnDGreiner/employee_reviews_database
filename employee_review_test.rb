require 'minitest/autorun'
require 'minitest/pride'

#Note: This line is going to fail first.
require './department.rb'
require './departments_migration.rb'
require './employee.rb'
require './employees_migration.rb'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'test.sqlite3')

ActiveRecord::Migration.verbose = false

class EmployeeReviewTest < Minitest::Test

  def setup
    DepartmentsMigration.migrate(:up)
    EmployeesMigration.migrate(:up)
  end

  def teardown
    DepartmentsMigration.migrate(:down)
    EmployeesMigration.migrate(:down)
  end


  def test_department_exists
    assert Department
  end

  def test_create_department_name
    Department.create(name: "Development")

    assert_equal "Development", Department.last.name
    assert_equal 1, Department.count
  end

  def test_save_employee
    Employee.create(name: "Dutch Matrix", email: "Commando@example.com", phone_number: "919-877-1276", salary: 90000)

    assert_equal "Dutch Matrix", Employee.last.name
    assert_equal 1, Employee.count
  end

  def test_get_employee_name
    Department.create(name: "Development")
    Employee.create(name: "Dutch Matrix", email: "Commando@example.com", phone_number: "919-877-1276", salary: 90000)

    assert_equal "Dutch Matrix", Employee.last.name
  end

  def test_get_employee_email
    Department.create(name: "Development")
    Employee.create(email: "Commando@example.com", phone_number: "919-877-1276", salary: 90000, name: "Dutch Matrix")

    assert_equal "Commando@example.com", Employee.last.email
  end

  def test_get_employee_phone
    Department.create(name: "Development")
    Employee.create(name: "Dutch Matrix", email: "Commando@example.com", phone_number: "919-877-1276", salary: 90000)

    assert_equal "919-877-1276", Employee.last.phone_number
  end

  def test_get_employee_salary
    Department.create(name: "Development")
    Employee.create(name: "Dutch Matrix", email: "Commando@example.com", phone_number: "919-877-1276", salary: 90000)

    assert_equal 90000, Employee.last.salary
  end

  def test_add_employee_to_department
    development = Department.create(name: "Development")
    employee = Employee.create(name: "Dutch Matrix", email: "Commando@example.com", phone_number: "919-877-1276", salary: 90000)

    assert development.add_employee(employee)
    assert_equal development.id, Employee.last.department_id
  end

  def test_total_salaries_of_a_department
    department = Department.create(name: "Development")
    employee_one = Employee.create(name: "Dutch Matrix", email: "Commando@example.com", phone_number: "919-877-1276", salary: 90000)
    employee_two = Employee.create(name: "John Rambo", email: "Rambo@example.com", phone_number: "919-999-1276", salary: 10000)

    assert department.add_employee(employee_one)
    assert department.add_employee(employee_two)
    assert_equal 100000, department.salary_total
  end

  def test_add_satisfactory_boolean
    employee_one = Employee.create(name: "Dutch Matrix", email: "Commando@example.com", phone_number: "919-877-1276", salary: 90000)

    assert employee_one.satisfactory?(true)
    assert_equal true, employee_one.satisfactory
  end

  def test_employee_can_get_raise
    employee_one = Employee.create(name: "Dutch Matrix", email: "Commando@example.com", phone_number: "919-877-1276", salary: 90000)

    assert employee_one.give_raise(10000.95)
    assert_equal 100000.95, employee_one.salary
  end

  def test_giving_department_a_raise
    development = Department.create(name: "Development")
    sales = Department.create(name: "sales")
    employee_one = Employee.create(name: "Clark Kent", email: "superman@example.com", phone_number: "111-111-1111", salary: 90000)
    employee_two = Employee.create(name: "Barry Allen", email: "flash@example.com", phone_number: "222-222-2222", salary: 50000)
    employee_three = Employee.create(name: "Oliver Queen", email: "green@example.com", phone_number: "333-333-3333", salary: 10000)
    employee_sales = Employee.create(name: "Tony Stark", email: "ironman@example.com", phone_number: "444-444-4444", salary: 100000)
    employee_one.satisfactory?(true)
    employee_two.satisfactory?(true)
    employee_three.satisfactory?(false)
    employee_sales.satisfactory?(true)

    assert development.add_employee(employee_one)
    assert development.add_employee(employee_two)
    assert development.add_employee(employee_three)
    assert sales.add_employee(employee_sales)
    assert development.give_raise(10000) {|e| e.salary > 10000}
    assert sales.give_raise(50000) {|e| e.satisfactory == true}
    assert_equal 95000.00, employee_one.salary
    assert_equal 55000.00, employee_two.salary
    assert_equal 10000.00, employee_three.salary
    assert_equal 150000.00, employee_sales.salary

  end

  def test_count_employees_in_department
    development = Department.create(name: "Development")
    sales = Department.create(name: "sales")
    employee_one = Employee.create(name: "Clark Kent", email: "superman@example.com", phone_number: "111-111-1111", salary: 90000)
    employee_two = Employee.create(name: "Barry Allen", email: "flash@example.com", phone_number: "222-222-2222", salary: 50000)
    employee_three = Employee.create(name: "Oliver Queen", email: "green@example.com", phone_number: "333-333-3333", salary: 10000)
    employee_sales = Employee.create(name: "Tony Stark", email: "ironman@example.com", phone_number: "444-444-4444", salary: 100000)
    development.add_employee(employee_one)
    development.add_employee(employee_two)
    development.add_employee(employee_three)
    sales.add_employee(employee_sales)

    assert_equal 3, development.employees_count
    assert_equal 1, sales.employees_count
  end

  def test_get_lowest_paid_employee_name
    development = Department.create(name: "Development")
    employee_one = Employee.create(name: "Clark Kent", email: "superman@example.com", phone_number: "111-111-1111", salary: 90000)
    employee_two = Employee.create(name: "Barry Allen", email: "flash@example.com", phone_number: "222-222-2222", salary: 50000)
    employee_three = Employee.create(name: "Oliver Queen", email: "green@example.com", phone_number: "333-333-3333", salary: 10000)
    development.add_employee(employee_one)
    development.add_employee(employee_two)
    development.add_employee(employee_three)

    assert_equal "Oliver Queen", development.lowest_salary
  end

  def test_order_employees_by_name
    development = Department.create(name: "Development")
    employee_one = Employee.create(name: "Clark Kent", email: "superman@example.com", phone_number: "111-111-1111", salary: 90000)
    employee_two = Employee.create(name: "Barry Allen", email: "flash@example.com", phone_number: "222-222-2222", salary: 50000)
    employee_three = Employee.create(name: "Oliver Queen", email: "green@example.com", phone_number: "333-333-3333", salary: 10000)
    development.add_employee(employee_one)
    development.add_employee(employee_two)
    development.add_employee(employee_three)

    assert_equal ["Barry Allen", "Clark Kent", "Oliver Queen"], development.alphabetize_a
  end

  def test_higher_than_average_salaries
    development = Department.create(name: "Development")
    employee_one = Employee.create(name: "Clark Kent", email: "superman@example.com", phone_number: "111-111-1111", salary: 90000)
    employee_two = Employee.create(name: "Barry Allen", email: "flash@example.com", phone_number: "222-222-2222", salary: 50000)
    employee_three = Employee.create(name: "Oliver Queen", email: "green@example.com", phone_number: "333-333-3333", salary: 10000)
    development.add_employee(employee_one)
    development.add_employee(employee_two)
    development.add_employee(employee_three)

    assert_equal ["Clark Kent"], development.above_average_salaries
  end

  def test_return_names_that_are_palindromes
    development = Department.create(name: "Development")
    employee_one = Employee.create(name: "Bob", email: "superman@example.com", phone_number: "111-111-1111", salary: 90000)
    employee_two = Employee.create(name: "Bill", email: "flash@example.com", phone_number: "222-222-2222", salary: 50000)
    employee_three = Employee.create(name: "Oliver Queen", email: "green@example.com", phone_number: "333-333-3333", salary: 10000)
    development.add_employee(employee_one)
    development.add_employee(employee_two)
    development.add_employee(employee_three)

    assert_equal ["Bob"], development.pal_names
  end

  def test_department_with_most_employees
    development = Department.create(name: "Development")
    sales = Department.create(name: "sales")
    employee_one = Employee.create(name: "Clark Kent", email: "superman@example.com", phone_number: "111-111-1111", salary: 90000)
    employee_two = Employee.create(name: "Barry Allen", email: "flash@example.com", phone_number: "222-222-2222", salary: 50000)
    employee_three = Employee.create(name: "Oliver Queen", email: "green@example.com", phone_number: "333-333-3333", salary: 10000)
    employee_sales = Employee.create(name: "Tony Stark", email: "ironman@example.com", phone_number: "444-444-4444", salary: 100000)
    development.add_employee(employee_one)
    development.add_employee(employee_two)
    development.add_employee(employee_three)
    sales.add_employee(employee_sales)

    assert_equal "Development", sales.most_employees?

  end

  def test_moving_employees_to_new_department
    development = Department.create(name: "Development")
    sales = Department.create(name: "Sales")
    employee_one = Employee.create(name: "Clark Kent", email: "superman@example.com", phone_number: "111-111-1111", salary: 90000)
    employee_two = Employee.create(name: "Barry Allen", email: "flash@example.com", phone_number: "222-222-2222", salary: 50000)
    employee_three = Employee.create(name: "Oliver Queen", email: "green@example.com", phone_number: "333-333-3333", salary: 10000)
    employee_sales = Employee.create(name: "Tony Stark", email: "ironman@example.com", phone_number: "444-444-4444", salary: 100000)
    development.add_employee(employee_one)
    development.add_employee(employee_two)
    development.add_employee(employee_three)
    sales.add_employee(employee_sales)

    refute_equal 4, development.employees_count
    assert sales.move_employees(development)
    assert_equal 4, development.employees_count

  end

  def test_give_percent_raise_to_all_employees
    development = Department.create(name: "Development")
    sales = Department.create(name: "sales")
    employee_one = Employee.create(name: "Clark Kent", email: "superman@example.com", phone_number: "111-111-1111", salary: 90000)
    employee_two = Employee.create(name: "Barry Allen", email: "flash@example.com", phone_number: "222-222-2222", salary: 50000)
    employee_three = Employee.create(name: "Oliver Queen", email: "green@example.com", phone_number: "333-333-3333", salary: 10000)
    employee_sales = Employee.create(name: "Tony Stark", email: "ironman@example.com", phone_number: "444-444-4444", salary: 100000)
    employee_one.satisfactory?(true)
    employee_two.satisfactory?(true)
    employee_three.satisfactory?(false)
    employee_sales.satisfactory?(true)
    development.add_employee(employee_one)
    development.add_employee(employee_two)
    development.add_employee(employee_three)
    sales.add_employee(employee_sales)

    development.per_raise(0.10)
    assert_equal 99000.00, employee_one.salary
    assert_equal 55000.00, employee_two.salary
    assert_equal 10000.00, employee_three.salary
    assert_equal 110000.00, employee_sales.salary

  end


end
