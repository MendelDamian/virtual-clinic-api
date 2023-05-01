# frozen_string_literal: true

class ChatSerializer < ActiveModel::Serializer
  attributes :id, :channel_name

  belongs_to :doctor, serializer: DoctorSerializer
  belongs_to :patient, serializer: PatientSerializer
end
