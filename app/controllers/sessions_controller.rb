class SessionsController < ApplicationController
  before_action :redirect_logged_in_user, only: [:new, :create]

  def new
    # ログインフォームを表示
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: 'ログインしました'
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードに誤りがあります'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: 'ログアウトしました'
  end

  private

  def redirect_logged_in_user
    if logged_in?
      redirect_to tasks_path, notice: 'ログアウトしてください'
    end
  end
end
