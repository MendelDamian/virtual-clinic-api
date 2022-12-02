class Procedure < ApplicationRecord
  belongs_to :user, inverse_of: :procedures, foreign_key: :users_id
  
  validates_uniqueness_of :name, scope: :users_id
  validates :name, length: { minimum: 2 , maximum: 128}
  validates :needed_time, presence: true

  validate :time_length_validation

  private

  def time_length_validation(record)
    shortest_procedure = "00:20"

    if record.needed_time.strftime('%H:%M') < shortest_procedure
      record.errors.add :base, "The time of procedure is too short"
    end
  end
end
