module ApiHelpers
  def json
    JSON.parse(response.body)
  end

  def json_errors
    json["errors"]
  end

  def session_user_id
    session["warden.user.user.key"][0][0]
  rescue
    nil
  end
end