class Api::V1::RegistrationsController < Devise::RegistrationsController
  def create
    # Remove professions from params
    params_professions = params[:user]&.delete(:professions)

    super do |resource|
      next unless resource.persisted? && resource.account_type_doctor? && params_professions.present?

      add_professions_to_doctor(resource, params_professions)
    end
  end

  def update
    # Remove professions from params
    params_professions = params[:user]&.delete(:professions)

    super do |resource|
      next unless resource.persisted? && resource.account_type_doctor? && params_professions.present?

      UserProfession.delete_by(user_id: resource.id)
      add_professions_to_doctor(resource, params_professions)
    end
  end

  def destroy
    if current_user.account_type_doctor?
      current_user.becomes(Doctor).destroy!
    else
      current_user.becomes(Patient).destroy!
    end
  end

  private

  def add_professions_to_doctor(doctor, params_professions)
    entries = []
    Profession.where(name: params_professions).find_each do |profession|
      entries << { user_id: doctor.id, profession_id: profession.id }
    end

    UserProfession.insert_all(entries) if entries.any?
  end
end
