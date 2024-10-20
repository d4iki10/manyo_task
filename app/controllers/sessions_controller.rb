class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def new
    # ログインフォームを表示
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      flash[:notice] = t('flash.login')
      redirect_to tasks_path
    else
      flash.now[:danger] = t('alert.login_failed')
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = t('flash.logout')
    redirect_to new_session_path
  end
end
