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
  def give_raise(percent)
    need_raise = employees.select { |e| yield(e)}
    need_raise.each { |e| e.give_raise(percent)}
  end

  def employees_count
    employees.count
  end

  def lowest_salary
    employees.order(:salary).first.name
  end

  def alphabetize_a
    employees.order(:name).map {|a| a.name}
  end

  def above_average_salaries
    array = []
    avg = salary_total.to_f/employees.count
    employees.each { |e|
      if e.salary > avg
        array << e.name
      end }
    array
  end

  def pal_names
    palindromes = employees.select { |e|
      e.name if e.name.reverse.downcase == e.name.downcase }
    palindromes.map { |p| p.name }
  end

  def most_employees?
    department_n = Department.count
    num = 1
    total = 0
    hold_total = 0
    d_id = 0

    department_n.times do
      total =  Employee.where(department_id: num ).count
      if hold_total < total
        hold_total = total
        d_id = num
      end
      num += 1
    end
    Department.find(d_id).name
  end

  def move_employees(dep)
    dep_id = 0
    dep_id = dep.id
    employees.each { |e|
      e.department_id = dep_id
      e.save}
  end

end
