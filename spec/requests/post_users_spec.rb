require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    context "with valid parameters" do
      let(:user_attributes) { FactoryBot.attributes_for(:user) }

      before do
        post "/users", params: { user: user_attributes }
      end

      subject(:user) { User.last }

      it_behaves_like "valid_response"
    end

    context "with invalid parameters" do
      let(:invalid_email) { "invalid_email" }
      let(:user_attributes) { FactoryBot.attributes_for(:user, email: invalid_email) }

      before do
        post "/users", params: { user: user_attributes }
      end

      it_behaves_like "invalid_response", [{ "email" => ["is invalid"] }]
    end

    context "with missing parameters" do
      let(:user_attributes) { FactoryBot.attributes_for(:user, email: nil) }

      before do
        post "/users", params: { user: user_attributes }
      end

      it_behaves_like "invalid_response", [{ "email" => ["can't be blank"] }]
    end

    context "with no parameters" do
      before do
        post "/users"
      end

      expected_errors = [
        { "email" => ["can't be blank"] },
        { "password" => ["can't be blank"] },
        { "first_name" => ["is too short (minimum is 2 characters)"] },
        { "last_name" => ["is too short (minimum is 2 characters)"] }
      ]

      it_behaves_like "invalid_response", expected_errors
    end

    context "with duplicate email" do
      let(:user_attributes) { FactoryBot.attributes_for(:user) }

      before do
        FactoryBot.create(:user, email: user_attributes[:email])
        post "/users", params: { user: user_attributes }
      end

      it_behaves_like "invalid_response", [{ "email" => ["has already been taken"] }]
    end

    context "with invalid account type" do
      let(:user_attributes) { FactoryBot.attributes_for(:user, account_type: "invalid") }

      before do
        post "/users", params: { user: user_attributes }
      end

      it_behaves_like "invalid_response", [{ "account_type" => ["is not a valid account type"] }]
    end

    context "with missing account type" do
      let(:user_attributes) { FactoryBot.attributes_for(:user, account_type: nil) }

      before do
        post "/users", params: { user: user_attributes }
      end

      subject(:user) { User.last }

      it_behaves_like "valid_response"

      it "sets account type to patient" do
        expect(user.account_type).to eq("patient")
      end
    end

    context "as a doctor" do
      context "with valid profession" do
        let(:profession) { FactoryBot.create(:profession) }
        let(:user_attributes) { FactoryBot.attributes_for(:doctor, professions: [profession.name]) }

        before do
          post "/users", params: { user: user_attributes }
        end

        subject(:user) { Doctor.last }

        it_behaves_like "valid_response"

        it "assigns the profession to the doctor" do
          expect(user.professions).to eq([profession])
        end
      end

      context "with invalid profession" do
        let(:invalid_profession) { "invalid_profession" }
        let(:user_attributes) { FactoryBot.attributes_for(:doctor, professions: [invalid_profession]) }

        before do
          post "/users", params: { user: user_attributes }
        end

        subject(:user) { Doctor.last }

        it_behaves_like "valid_response"

        it "does not assign profesion to the doctor" do
          expect(user.professions).to be_empty
        end
      end

      context "with missing profession" do
        let(:user_attributes) { FactoryBot.attributes_for(:doctor, professions: nil) }

        before do
          post "/users", params: { user: user_attributes }
        end

        subject(:user) { Doctor.last }

        it "does not assign profesion to the doctor" do
          expect(user.professions).to be_empty
        end
      end

      context "with mixed valid and invalid professions" do
        let(:profession) { FactoryBot.create(:profession) }
        let(:invalid_profession) { "invalid_profession" }
        let(:user_attributes) { FactoryBot.attributes_for(:doctor, professions: [profession.name, invalid_profession]) }

        before do
          post "/users", params: { user: user_attributes }
        end

        subject(:user) { Doctor.last }

        it_behaves_like "valid_response"

        it "assigns the valid profession to the doctor" do
          expect(user.professions).to eq([profession])
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

        subject(:user) { Patient.last }

        it_behaves_like "valid_response"

        it "does not assign the profession to the patient" do
          expect(profession.doctors).to be_empty
        end
      end
    end
  end
end
