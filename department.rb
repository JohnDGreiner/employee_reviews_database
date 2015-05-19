require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'employee_reviews_db.sqlite3')

class Department < ActiveRecord::Base
  has_many :employees

  def add_employee(employee)
    employees << employee
  end

  # total the salaries of all employees in a department
  def salary_total
    employees.map {|e| e.salary}.reduce(:+)
  end

  # give a raise to employees in a department based on conditions in a block
  def give_raise(amount)
    need_raise = employees.select { |e| yield(e)}
    need_raise.each { |e| e.give_raise(amount/need_raise.length)}
  end

  def employees_count
    employees.count
  end

  def lowest_salary
    employees.order(:salary).first.name
  end

end
