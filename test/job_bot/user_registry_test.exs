defmodule JobBot.UserRegistryTest do
  use ExUnit.Case, async: true

  import Mock

  setup do
    Agent.update(JobBot.UserRegistry, fn (_) -> %{} end)
    :ok
  end

  test "register/2 adds a user to the registry" do
    user_id = 1
    opts = [autoapply: true, sources: []]
    
    JobBot.UserRegistry.register(user_id, opts)
    retreived = Agent.get(JobBot.UserRegistry, &Map.get(&1, user_id))

    assert retreived == opts
  end

  test "register/1 gets the data associated with a user" do
    user_id = 1
    opts = [autoapply: true, sources: []]
    JobBot.UserRegistry.register(user_id, opts)

    data = JobBot.UserRegistry.get_user_data(user_id)

    assert data == opts
  end

  test "register/2 gets the data key associated with a user" do
    value = :target_value
    opts = [autoapply: true, sources: [], target_key: value]
    user_id = 1
    JobBot.UserRegistry.register(user_id, opts)

    retreived = JobBot.UserRegistry.get_user_data(user_id, :target_key)

    assert retreived == value
  end

  test "unregister/1 removes the user from the registry" do
    user_id = 1
    JobBot.UserRegistry.register(user_id, [])
    JobBot.UserRegistry.unregister(user_id)

    registry = Agent.get(JobBot.UserRegistry, & &1)

    assert registry == %{}
  end

  test "unregister/1 deletes their reumse" do
    with_mock(JobBotWeb.Upload, [delete: fn(_path) -> nil end]) do
      user_id = 1
      resume_path = "uploads/tmp/resumes/test/resume.pdf"
      JobBot.UserRegistry.register(user_id, [resume_path: resume_path])
      JobBot.UserRegistry.unregister(user_id)

      assert called JobBotWeb.Upload.delete(resume_path)
    end
  end
end