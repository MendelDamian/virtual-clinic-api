class Api::V1::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted? && resource.account_type_doctor?
        params_professions = params[:user][:professions]

        entries = []
        Profession.where(name: params_professions).find_each do |profession|
          entries << { user_id: resource.id, profession_id: profession.id }
        end

        UserProfession.insert_all(entries)
      end
    end
  end

  def update
    super do |resource|
      if resource.persisted? && resource.account_type_doctor?
        params_professions = params[:user][:professions]

        # If professions are not sent, then do nothing. It's recommended to do not send this param if it's not modified.
        if params_professions.nil?
          return
        end

        # If so, then delete all professions for this doctor.
        UserProfession.where(user_id: resource.id).delete_all

        # And add the new ones.
        entries = []
        Profession.where(name: params_professions).find_each do |profession|
          entries << { user_id: resource.id, profession_id: profession.id }
        end

        UserProfession.insert_all(entries)
      end
    end
  end
end
