class SessionsController < ApplicationController
  before_action :redirect_logged_in_user, only: [:new, :create]

  def new
    # ログインフォームを表示
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = 'ログインしました'
      redirect_to tasks_path
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードに誤りがあります'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to new_session_path
  end

  private

  def redirect_logged_in_user
    if logged_in?
      flash[:notice] = 'ログアウトしてください'
      redirect_to tasks_path
    end
  end
end
