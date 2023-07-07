class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :filter_params, only: %i[index]
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.unscope(where: :status).all
    @users = @users.where(role: filter_params[:role]) if filter_params[:role].present?
    @users = @users.where(status: filter_params[:status]) if filter_params[:status].present?
    @users = @users.search(filter_params[:q]) if filter_params[:q].present?
    @users = @users.paginate(page: page_num, per_page: items_per_page)

    @totals = {
      total_users: User.unscope(where: :status).all.count,
      pending_users: User.unscope(where: :status).status_pending.count,
      active_users: User.unscope(where: :status).status_active.count,
      inactive_users: User.unscope(where: :status).status_inactive.count,
    }

    render json: @users, meta: { pagination: pagination_dict(@users), totals: @totals }, status: :ok
  end

  def dev_users
    devusers = User.where(role: "developer")
    devusers = devusers.where(company_id: params[:company_id]) if params[:company_id].present?
    render json: devusers, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @user, status: :ok
    end
  end

  def destroy
    unless @user.destroy
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @user, status: :ok
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.unscope(where: :status).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "User not found" }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:email, :password, :name, :role, :company_id, :status)
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : User.per_page
  end

  def page_num
    filter_params[:options] && JSON.parse(filter_params[:options]).deep_symbolize_keys[:page] ? JSON.parse(filter_params[:options]).deep_symbolize_keys[:page] : 1
  end

  def filter_params
    params.slice(:role, :status, :q, :options)
  end
end
