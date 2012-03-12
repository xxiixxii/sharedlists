# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  before_filter :login_required!

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def login_required!
    if current_user.nil?
      flash[:error] = "Login required"
      redirect_to log_in_url
    end
  end

  def authenticate_supplier_admin!
    @supplier = Supplier.find((params[:supplier_id] || params[:id]))
    if UserAccess.first(:conditions => {:supplier_id => @supplier, :user_id => current_user}).nil?
      flash[:error] = "Not authorized!"
      redirect_to root_url
    end
  end
end
