require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    context "with valid parameters" do
      let(:user_attributes) { FactoryBot.attributes_for(:user) }

      before do
        post "/users", params: { user: user_attributes }
      end

      subject(:user) { User.last }

      it_behaves_like "valid_user_creation_request"
    end

    context "with invalid parameter" do
      let(:invalid_email) { "invalid_email" }
      let(:user_attributes) { FactoryBot.attributes_for(:user, email: invalid_email) }

      before do
        post "/users", params: { user: user_attributes }
      end

      it_behaves_like "invalid_user_creation_request", [{ "email" => ["is invalid"] }]
    end

    context "with missing parameter" do
      let(:user_attributes) { FactoryBot.attributes_for(:user, email: nil) }

      before do
        post "/users", params: { user: user_attributes }
      end

      it_behaves_like "invalid_user_creation_request", [{ "email" => ["can't be blank"] }]
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

      it_behaves_like "invalid_user_creation_request", expected_errors
    end

    context "with duplicate email" do
      let(:user_attributes) { FactoryBot.attributes_for(:user) }

      before do
        FactoryBot.create(:user, email: user_attributes[:email])
        post "/users", params: { user: user_attributes }
      end

      it_behaves_like "invalid_user_creation_request", [{ "email" => ["has already been taken"] }]
    end

    context "with invalid account type" do
      let(:user_attributes) { FactoryBot.attributes_for(:user, account_type: "invalid") }

      before do
        post "/users", params: { user: user_attributes }
      end

      it_behaves_like "invalid_user_creation_request", [{ "account_type" => ["is not a valid account type"] }]
    end

    context "with missing account type" do
      let(:user_attributes) { FactoryBot.attributes_for(:user, account_type: nil) }

      before do
        post "/users", params: { user: user_attributes }
      end

      subject(:user) { User.last }

      it_behaves_like "valid_user_creation_request"

      it "sets default account type" do
        expect(user.account_type).to eq("patient")
      end
    end

    context "as a doctor" do
      context "with existing profession" do
        let(:profession) { FactoryBot.create(:profession) }
        let(:user_attributes) { FactoryBot.attributes_for(:doctor, professions: [profession.name]) }

        before do
          post "/users", params: { user: user_attributes }
        end

        subject(:user) { Doctor.last }

        it_behaves_like "valid_user_creation_request"

        it "assigns the profession to the doctor" do
          expect(user.professions).to eq([profession])
        end
      end

      context "with duplicated professions" do
        let(:profession) { FactoryBot.create(:profession) }
        let(:user_attributes) { FactoryBot.attributes_for(:doctor, professions: [profession.name, profession.name]) }

        before do
          post "/users", params: { user: user_attributes }
        end

        subject(:user) { Doctor.last }

        it_behaves_like "valid_user_creation_request"

        it "ignores duplications and assigns just one profession" do
          expect(user.professions).to eq([profession])
        end
      end

      context "with not existing profession" do
        let(:not_existing_profession) { "Definitely not existing" }
        let(:user_attributes) { FactoryBot.attributes_for(:doctor, professions: [not_existing_profession]) }

        before do
          post "/users", params: { user: user_attributes }
        end

        subject(:user) { Doctor.last }

        it_behaves_like "valid_user_creation_request"

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

        it_behaves_like "valid_user_creation_request"

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

        it_behaves_like "valid_user_creation_request"

        it "does not assign anyone to profession" do
          expect(profession.doctors).to be_empty
        end
      end
    end
  end
end
