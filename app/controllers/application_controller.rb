class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def login_required
    unless logged_in?
      flash[:alert] = 'ログインしてください'
      redirect_to new_session_path unless current_user
    end
  end
end
