RSpec.shared_examples "valid_response" do
  it "returns a 201 status code" do
    expect(response).to have_http_status(201)
  end

  it "returns the correct json" do
    expect(json).to include(user.as_json)
  end

  it "creates a session with the last created user" do
    expect(session_user_id).to eq(user.id)
  end
end

RSpec.shared_examples "invalid_response" do |expected_errors|
  it "returns a 422 status code" do
    expect(response).to have_http_status(422)
  end

  expected_errors.each do |errors|
    field = errors.keys.first
    it "returns the json with #{field} error" do
      expect(json_errors).to include(errors)
    end
  end

  it "does not create a session" do
    expect(session_user_id).to be_nil
  end
end
