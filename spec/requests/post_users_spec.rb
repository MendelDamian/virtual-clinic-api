require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    context "with valid parameters" do
      let(:user_attributes) { FactoryBot.attributes_for(:user) }

      before do
        post "/users", params: { user: user_attributes }
      end

      subject(:user) { User.last }

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

    context "with invalid parameters" do
      let(:invalid_email) { "invalid_email" }
      let(:user_attributes) { FactoryBot.attributes_for(:user, email: invalid_email) }

      before do
        post "/users", params: { user: user_attributes }
      end

      it "returns a 422 status code" do
        expect(response).to have_http_status(422)
      end

      it "returns the correct json" do
        expect(json_errors).to include({ "email" => ["is invalid"] })
      end

      it "does not create a session" do
        expect(session_user_id).to be_nil
      end
    end

    context "with missing parameters" do
      let(:user_attributes) { FactoryBot.attributes_for(:user, email: nil) }

      before do
        post "/users", params: { user: user_attributes }
      end

      it "returns a 422 status code" do
        expect(response).to have_http_status(422)
      end

      it "returns the correct json" do
        expect(json_errors).to include(User.create(user_attributes).errors.as_json.deep_stringify_keys)
      end

      it "does not create a session" do
        expect(session_user_id).to be_nil
      end
    end

    context "with no parameters" do
      before do
        post "/users"
      end

      it "returns a 422 status code" do
        expect(response).to have_http_status(422)
      end

      it "returns the correct json" do
        expect(json_errors).to include(User.create.errors.as_json.deep_stringify_keys)
      end

      it "does not create a session" do
        expect(session_user_id).to be_nil
      end
    end

    context "with duplicate email" do
      let(:user_attributes) { FactoryBot.attributes_for(:user) }

      before do
        FactoryBot.create(:user, email: user_attributes[:email])
        post "/users", params: { user: user_attributes }
      end

      it "returns a 422 status code" do
        expect(response).to have_http_status(422)
      end

      it "returns the correct json" do
        expect(json_errors).to include({ "email" => ["has already been taken"] })
      end

      it "does not create a session" do
        expect(session_user_id).to be_nil
      end
    end

    context "with invalid account type" do
      let(:user_attributes) { FactoryBot.attributes_for(:user, account_type: "invalid") }

      before do
        post "/users", params: { user: user_attributes }
      end

      it "returns a 422 status code" do
        expect(response).to have_http_status(422)
      end

      it "returns the correct json" do
        expect(json_errors).to include({ "account_type" => ["is not a valid account type"] })
      end

      it "does not create a session" do
        expect(session_user_id).to be_nil
      end
    end

    context "with missing account type" do
      let(:user_attributes) { FactoryBot.attributes_for(:user, account_type: nil) }

      before do
        post "/users", params: { user: user_attributes }
      end

      it "returns a 201 status code" do
        expect(response).to have_http_status(201)
      end

      subject(:user) { User.last }

      it "sets account type to patient" do
        expect(user.account_type).to eq("patient")
      end

      it "returns the correct json" do
        expect(json).to include(user.as_json)
      end

      it "creates a session with the last created user" do
        expect(session_user_id).to eq(user.id)
      end
    end

    context "as a doctor" do
      context "with valid profession" do
        let(:profession) { FactoryBot.create(:profession) }
        let(:user_attributes) { FactoryBot.attributes_for(:doctor, professions: [profession.name]) }

        before do
          post "/users", params: { user: user_attributes }
        end

        it "returns a 201 status code" do
          expect(response).to have_http_status(201)
        end

        subject(:doctor) { Doctor.last }

        it "assigns the profession to the doctor" do
          expect(doctor.professions).to eq([profession])
        end

        it "returns the correct json" do
          expect(json).to include(doctor.as_json)
        end

        it "creates a session with the last created user" do
          expect(session_user_id).to eq(User.last.id)
        end
      end

      context "with invalid profession" do
        let(:invalid_profession) { "invalid_profession" }
        let(:user_attributes) { FactoryBot.attributes_for(:doctor, professions: [invalid_profession]) }

        before do
          post "/users", params: { user: user_attributes }
        end

        it "returns a 201 status code" do
          expect(response).to have_http_status(201)
        end

        subject(:doctor) { Doctor.last }

        it "does not assign profesion to the doctor" do
          expect(doctor.professions).to be_empty
        end

        it "returns the correct json" do
          expect(json).to include(doctor.as_json)
        end

        it "creates a session with the last created user" do
          expect(session_user_id).to eq(User.last.id)
        end
      end

      context "with missing profession" do
        let(:user_attributes) { FactoryBot.attributes_for(:doctor, professions: nil) }

        before do
          post "/users", params: { user: user_attributes }
        end

        it "returns a 201 status code" do
          expect(response).to have_http_status(201)
        end

        subject(:doctor) { Doctor.last }

        it "does not assign profesion to the doctor" do
          expect(doctor.professions).to be_empty
        end

        it "returns the correct json" do
          expect(json).to include(doctor.as_json)
        end

        it "creates a session with the last created user" do
          expect(session_user_id).to eq(User.last.id)
        end
      end

      context "with mixed valid and invalid professions" do
        let(:profession) { FactoryBot.create(:profession) }
        let(:invalid_profession) { "invalid_profession" }
        let(:user_attributes) { FactoryBot.attributes_for(:doctor, professions: [profession.name, invalid_profession]) }

        before do
          post "/users", params: { user: user_attributes }
        end

        it "returns a 201 status code" do
          expect(response).to have_http_status(201)
        end

        subject(:doctor) { Doctor.last }

        it "assigns the valid profession to the doctor" do
          expect(doctor.professions).to eq([profession])
        end

        it "returns the correct json" do
          expect(json).to include(doctor.as_json)
        end

        it "creates a session with the last created user" do
          expect(session_user_id).to eq(User.last.id)
        end
      end
    end

    context "as a patient" do
      context "with provided valid profession" do
        let(:profession) { FactoryBot.create(:profession) }
        let(:user_attributes) { FactoryBot.attributes_for(:patient, professions: [profession.name]) }

        before do
          post "/users", params: { user: user_attributes }
        end

        it "returns a 201 status code" do
          expect(response).to have_http_status(201)
        end

        subject(:patient) { Patient.last }

        it "does not assign the profession to the patient" do
          expect(profession.doctors).to be_empty
        end

        it "returns the correct json" do
          expect(json).to include(patient.as_json)
        end

        it "creates a session with the last created user" do
          expect(session_user_id).to eq(User.last.id)
        end
      end
    end
  end
end
