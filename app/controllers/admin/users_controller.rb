class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.includes(:tasks).order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: 'ユーザを登録しました'
    else
      render :new
    end
  end

  def show
    @tasks = @user.tasks.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'ユーザを更新しました'
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: 'ユーザを削除しました'
    else
      redirect_to admin_users_path, alert: '管理者が0人になるため削除できません'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_admin
    unless current_user.admin?
      redirect_to tasks_path, alert: '管理者以外アクセスできません'
    end
  end
end
