class Department
  attr_reader :name

  def initialize(name)
    @name = name
    @employees = []
  end

  def add_employee(employee)
    @employees << employee
  end

  # total the salaries of all employees in a department
  def salary_total
    s_total = 0
    @employees.map {|e| s_total += e.salary}
    s_total
  end

  # give a raise to employees in a department based on conditions in a block
  def give_raise(amount)
    need_raise = @employees.select { |e| yield(e)}
    need_raise.each { |e| e.give_raise(amount/need_raise.length)}
  end

end
