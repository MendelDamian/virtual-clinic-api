require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    context "with valid parameters" do
      let(:user_attributes) { FactoryBot.attributes_for(:user) }

      before do
        post "/users", params: { user: user_attributes }
      end

      it "returns a 201 status code" do
        expect(response).to have_http_status(201)
      end

      it "returns the correct json" do
        expect(response.body).to eq(User.last.to_json)
      end

      it "creates a session with the last created user" do
        expect(controller.current_user).to eq(User.last)
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
        expect(json["errors"]).to eq({ "email" => ["is invalid"] })
      end

      it "does not create a session" do
        expect(controller.current_user).to be_nil
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
        expect(json["errors"]).to eq({ "email" => ["can't be blank"] })
      end

      it "does not create a session" do
        expect(controller.current_user).to be_nil
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
        expect(json["errors"]).to eq({ "email" => ["has already been taken"] })
      end

      it "does not create a session" do
        expect(controller.current_user).to be_nil
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
        expect(json["errors"]).to eq({ "account_type" => ["is not a valid account type"] })
      end

      it "does not create a session" do
        expect(controller.current_user).to be_nil
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

      it "sets account type to patient" do
        expect(User.last.account_type).to eq("patient")
      end

      it "returns the correct json" do
        user = User.last
        expect(response.body).to eq(user.to_json)
      end

      it "creates a session with the last created user" do
        expect(controller.current_user).to eq(User.last)
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

        it "assigns the profession to the doctor" do
          expect(Doctor.last.professions).to eq([profession])
        end

        it "returns the correct json" do
          expect(response.body).to eq(User.last.to_json)
        end

        it "creates a session with the last created user" do
          expect(controller.current_user).to eq(User.last)
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

        it "does not assign profesion to the doctor" do
          expect(Doctor.last.professions).to be_empty
        end

        it "returns the correct json" do
          expect(response.body).to eq(User.last.to_json)
        end

        it "creates a session with the last created user" do
          expect(controller.current_user).to eq(User.last)
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

        it "does not assign profesion to the doctor" do
          expect(Doctor.last.professions).to be_empty
        end

        it "returns the correct json" do
          expect(response.body).to eq(User.last.to_json)
        end

        it "creates a session with the last created user" do
          expect(controller.current_user).to eq(User.last)
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

        it "assigns the valid profession to the doctor" do
          expect(Doctor.last.professions).to eq([profession])
        end

        it "returns the correct json" do
          expect(response.body).to eq(User.last.to_json)
        end

        it "creates a session with the last created user" do
          expect(controller.current_user).to eq(User.last)
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

        it "does not assign the profession to the patient" do
          expect(profession.doctors).to be_empty
        end

        it "returns the correct json" do
          expect(response.body).to eq(User.last.to_json)
        end

        it "creates a session with the last created user" do
          expect(controller.current_user).to eq(User.last)
        end
      end
    end
  end
end
