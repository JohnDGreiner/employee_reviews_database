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
    # array = Department.all
    # array.each {|d| d.employees_count}
    #p Employee.where(department_id: Department.all).count
    #Employee.each{ |e,i| e.where(department_id:i)}
    # department_max = Department.first
    # Department.all
    p Employee.each {|e| e.name}


  end

end
