class ProcedureSerializer < ActiveModel::Serializer
  attributes :id, :name, :needed_time_min

  belongs_to :doctor, foreign_key: :user_id
end
