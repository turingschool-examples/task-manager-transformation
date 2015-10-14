require 'yaml/store'

class TaskManager
  def self.database
    if ENV["RACK_ENV"] == "test"
      @database ||= YAML::Store.new("db/task_manager_test")
    else
      @database ||= YAML::Store.new("db/task_manager")
    end
  end

  def self.create(task)
    database.transaction do
      database['tasks'] ||= []
      database['total'] ||= 0
      database['total'] += 1
      database['tasks'] << { "id" => database['total'], "title" => task[:title], "description" => task[:description] }
    end
  end

  def self.update(id, data)
    database.transaction do
      target = database['tasks'].find { |task| task["id"] == id }
      target["title"] = data[:title]
      target["description"] = data[:description]
    end
  end

  def self.delete(id)
    database.transaction do
      database['tasks'].delete_if { |task| task["id"] == id }
    end
  end

  def self.raw_tasks
    database.transaction do
      database['tasks'] || []
    end
  end

  def self.all
    raw_tasks.map { |data| Task.new(data) }
  end

  def self.raw_task(id)
    raw_tasks.find { |task| task["id"] == id }
  end

  def self.find(id)
    Task.new(raw_task(id))
  end

  def self.delete_all
    database.transaction do
      database['tasks'] = []
      database['total'] = 0
    end
  end
end