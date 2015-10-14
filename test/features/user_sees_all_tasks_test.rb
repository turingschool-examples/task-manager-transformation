require_relative '../test_helper'

class UserSeesAllTasksTest < FeatureTest

  def create_tasks(num)
    num.times do |i|
      TaskManager.create({ :title       => "#{i+1} title",
                           :description => "#{i+1} description"})
    end
  end

  def test_new_task_creation
    visit("/")
    click_link("New Task")

    fill_in("task-title", with: "new task")
    fill_in("task-description", with: "new description")
    assert_equal "/tasks/new", current_path
    click_button("Create Task")
    assert_equal "/tasks", current_path

    within(".container") do
      assert page.has_content?("new task")
    end
  end

  def test_user_can_edit_a_task
    create_tasks(1)

    visit "/tasks"
    click_link("edit")
    fill_in("task-title", with: "new task edited")
    fill_in("task-description", with: "new description edited")
    click_button("Update Task")

    assert_equal "/tasks/1", current_path
    within(".container") do
      assert page.has_content?("new task edited")
    end
  end

  def test_user_can_delete_a_task
    create_tasks(1)
    
    visit "/tasks"
    click_button("delete")

    refute page.has_content?("new task")
  end

  def test_a_user_can_see_a_single_task
    create_tasks(1)

    visit "/tasks"

    click_link("1 title")
    assert_equal "/tasks/1", current_path
    assert page.has_content?("1 description")
  end
end
