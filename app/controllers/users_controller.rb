class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :redirect_logged_in_user, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to tasks_path, notice: 'アカウントを登録しました'
    else
      render :new
    end
  end

  def show
    # 自分のアカウント詳細を表示
  end

  def edit
    # 自分のアカウント編集
  end

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: 'アカウントを更新しました'
    else
      render :edit
    end
  end

  def destroy
    Rails.logger.info "Attempting to destroy user: #{@user.id}"
    if @user.destroy
      reset_session
      redirect_to new_session_path, notice: 'アカウントを削除しました'
    else
      flash[:alert] = 'アカウント削除に失敗しました'
      redirect_to user_path
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def require_login
    unless logged_in?
      redirect_to new_session_path, alert: 'ログインしてください'
    end
  end

  def correct_user
    unless @user == current_user
      redirect_to tasks_path, notice: 'アクセス権限がありません'
    end
  end

  def redirect_logged_in_user
    if logged_in?
      redirect_to tasks_path, alert: 'ログアウトしてください'
    end
  end
end
