class User < ApplicationRecord
  acts_as_paranoid

  has_one :developer
  has_many :skill_masters, class_name: "SkillMaster", foreign_key: "creater_id"
  has_many :domain_masters, class_name: "DomainMaster", foreign_key: "creater_id"
  belongs_to :company

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :validatable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :recoverable,
         :trackable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  validates :email, :uniqueness => true

  enum status: {
    pending: 0,
    active: 1,
    inactive: 2,
  }, _prefix: true, _default: :active

  default_scope { where(status: :active) }

  self.per_page = 10

  def self.search(search)
    wildcard_search = "%#{search}%"
    where("email ILIKE ? OR name ILIKE ?", wildcard_search, wildcard_search)
  end
end
