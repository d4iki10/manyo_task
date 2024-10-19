class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = t('flash.account_created')
      redirect_to tasks_path
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
      flash[:notice] = 'アカウントを更新しました'
      redirect_to user_path
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = 'アカウントを削除しました'
      redirect_to new_session_path
    else
      flash[:alert] = 'アカウント削除に失敗しました'
      redirect_to user_path
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    redirect_to current_path unless current_user?(@user)
  end
end
