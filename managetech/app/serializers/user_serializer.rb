class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :company_id, :role, :name, :status, :register_date, :last_sign_in_at, :avatar_url

  belongs_to :company
end
