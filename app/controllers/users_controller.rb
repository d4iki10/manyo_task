class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :correct_user, only: [:show]
  before_action :redirect_logged_in_user, only: [:new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:notice] = t('flash.account_created')
      redirect_to tasks_path
    else
      render :new
    end
  end

  def show
    # 自分のアカウント詳細を表示
    @user = User.find(params[:id])
  end

  def edit
    # 自分のアカウント編集
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'アカウントを更新しました'
      redirect_to user_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'アカウントを削除しました'
    redirect_to new_session_path
  end

  private

  def user_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params.require(:user).permit(:name, :email)
    else
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to current_user unless current_user?(@user)
  end

  # ログイン中のユーザーがアカウント登録画面にアクセスしようとしたらリダイレクト
  def redirect_logged_in_user
    if logged_in?
      flash[:alert] = 'ログアウトしてください'
      redirect_to tasks_path
    end
  end
end
