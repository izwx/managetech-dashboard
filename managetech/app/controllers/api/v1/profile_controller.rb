class Api::V1::ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
    user = current_user
    render json: user, status: :ok
  end

  def update
    user = current_user
    user.email = profile_params[:email]
    user.name = profile_params[:name]

    if user.save
      render json: user, status: :ok
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update_avatar
    user = current_user
    begin

      # Make an object in your bucket for your upload
      obj = AwsServices::FileUpload.new(params[:file]).call if params[:file].present?
      user.avatar_url = obj.public_url
      user.save
      render json: { url: obj.public_url, name: obj.key }, status: :ok
    rescue => e
      render json: { errors: e },
             status: :unprocessable_entity
    end
  end

  def delete_avatar
    begin
      user = current_user

      if params[:url].present?
        AwsServices::FileDelete.new(params[:url]).call
        user.avatar_url = nil
        user.save
        render json: { message: "Successfully removed" }, status: :ok
      else
        raise Exception.new("url parameter required!")
      end
    rescue => e
      render json: { errors: e },
             status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.permit(:email, :name)
  end
end
