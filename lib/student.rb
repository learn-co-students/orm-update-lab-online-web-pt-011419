require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade, :id
  
  def initialize(name, grade, id = nil)
    @name = name 
    @grade = grade
    @id = id
  end 
  
  def self.create_table
    sql = "CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER);"
    DB[:conn].execute(sql)
  end 
  
  def self.drop_table
    sql = "DROP TABLE students;"
    DB[:conn].execute(sql)
  end 
  
  def save 
    if self.id
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    else 
      sql = "INSERT INTO students (name, grade) VALUES (?, ?);"
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end 
  end
  
  def self.create(name, grade)
    new_student = self.new(name, grade)
    new_student.save
    new_student
  end 
  
  def self.new_from_db(row)
    new_student = self.new(nil, nil)
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end 
  
  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1;"
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end 
  
  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end 
end
