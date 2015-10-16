class TaskManager
  def self.database
    if ENV["RACK_ENV"] == "test"
      @database ||= Sequel.sqlite("db/task_manager_test.sqlite3")
    else
      @database ||= Sequel.sqlite("db/task_manager_development.sqlite3")
    end
  end

  def self.create(task)
    dataset.insert(task)
  end

  def self.update(id, data)
    task = dataset.where(:id => id)
    task.update(data)
  end

  def self.delete(id)
    dataset.where(:id=>id).delete
  end

  def self.all
    tasks = dataset.to_a
    tasks.map { |data| Task.new(data) }
  end

  def self.find(id)
    task = dataset.where(:id=>id).to_a.first
    Task.new(task)
  end

  def self.find_by(input)
    raw_tasks = dataset.where(input.keys.first => input.values.first).to_a
    raw_tasks.map { |data| Task.new(data) }
  end

  def self.dataset
    database.from(:tasks)
  end
end