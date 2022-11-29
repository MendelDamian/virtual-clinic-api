class Api::V1::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted? && resource.account_type_doctor?
        params_professions = params[:user][:professions]

        # For now I am skipping not found professions.
        professions_db = Profession.where(name: params_professions)
        professions_db.each do |profession|
          profession.user_professions << UserProfession.new(user_id: resource.id)
        end
      end
    end
  end
end
