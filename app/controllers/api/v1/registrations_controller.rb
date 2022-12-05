class Api::V1::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      next unless resource.persisted? && resource.account_type_doctor?

      params_professions = params[:user][:professions]
      add_professions_to_doctor(resource, params_professions) if params_professions.present?
    end
  end

  def update
    super do |resource|
      next unless resource.persisted? && resource.account_type_doctor?

      # If professions are not sent, then do nothing. It's recommended to do not send this param if it's not modified.
      params_professions = params[:user][:professions]
      return if params_professions.nil?

      # If so, then delete all professions for this doctor.
      UserProfession.delete_by(user_id: resource.id)

      # And add the new ones.
      add_professions_to_doctor(resource, params_professions)
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
