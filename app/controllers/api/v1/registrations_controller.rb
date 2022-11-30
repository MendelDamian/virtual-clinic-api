class Api::V1::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted? && resource.account_type_doctor?
        params_professions = params[:user][:professions]

        professions_db = Profession.where(name: params_professions)
        professions_db.each do |profession|
          profession.user_professions.create!(user_id: resource.id)
        end
      end
    end
  end

  def update
    super do |resource|
      if resource.persisted? && resource.account_type_doctor?
        params_professions = params[:user][:professions]

        # If professions are not sent, then do nothing. It's recommended to do not send a param if it's not modified.
        if params_professions.nil?
          return
        end

        # If so, then delete all professions for this doctor.
        UserProfession.where(user_id: resource.id).destroy_all

        # And add the new ones.
        professions_db = Profession.where(name: params_professions)
        professions_db.each do |profession|
          profession.user_professions.create!(user_id: resource.id)
        end
      end
    end
  end
end
