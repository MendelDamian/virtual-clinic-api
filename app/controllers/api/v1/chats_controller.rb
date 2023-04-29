# frozen_string_literal: true

class Api::V1::ChatsController < Api::V1::ApplicationController
  include ApiResponse
  before_action :require_patient, only: :create

  def index
    json_response
  end

  def create
    @chat = Chat.new(chat_params)
    if @chat.save
      render json: { data: @chat }, status: :created
    else
      render json: { errors: @chat.errors }, status: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:doctor_id).merge(patient_id: @curr_user.id)
  end

  def set_collection
    @collection = @curr_user.chats
  end

  def filtering_params
  end
end
