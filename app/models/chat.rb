# frozen_string_literal: true

class Chat < ApplicationRecord
  require 'securerandom'

  before_create :create_channel_name

  belongs_to :doctor, inverse_of: :chats, foreign_key: :doctor_id
  belongs_to :patient, inverse_of: :chats, foreign_key: :patient_id

  validates_uniqueness_of :doctor_id, scope: :patient_id

  private

  def create_channel_name
    self.channel_name = SecureRandom.urlsafe_base64(11)
  end
end
