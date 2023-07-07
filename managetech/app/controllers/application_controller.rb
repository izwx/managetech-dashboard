require "application_responder"

class ApplicationController < ActionController::API
  self.responder = ApplicationResponder
  respond_to :json

  include ActionController::MimeResponds

  def index
    render json: { message: "OK" }, status: :ok
  end

  def pagination_dict(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      per_page: collection.per_page,
      total_pages: collection.total_pages,
      total: collection.count,
    }
  end

  def signed_in?
    !!current_user
  end

  def is_admin?
    signed_in? ? current_user.role == "superAdmin" : false
  end
end
