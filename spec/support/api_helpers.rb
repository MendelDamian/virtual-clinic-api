module ApiHelpers
  def json
    JSON.parse(response.body)
  end

  def json_errors
    json["errors"]
  end

  def session_user_id
    controller.current_user.id
  rescue
    nil
  end
end
