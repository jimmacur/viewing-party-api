class ViewingParty < ApplicationRecord
  belongs_to :host, class_name: 'User', foreign_key: 'host_id'
  has_many :invitations
  has_many :invitees, through: :invitations, source: :user

  validates :name, :start_time, :end_time, :movie_id, :movie_title, presence: true
end
