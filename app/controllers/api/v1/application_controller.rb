class Api::V1::ApplicationController < ::ApplicationController
  before_action :authenticate_user!
  before_action :set_curr_user

  private

  def set_curr_user
    if current_user.account_type_doctor?
      @curr_user = current_user.becomes(Doctor)
    else
      @curr_user = current_user.becomes(Patient)
    end
  end
end
