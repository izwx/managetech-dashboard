# app/controllers/users/passwords_controller.rb
class Users::PasswordsController < Devise::PasswordsController
  respond_to :json
end
