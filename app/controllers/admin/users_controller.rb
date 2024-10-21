module Admin
  class UsersController < ApplicationController
    before_action :admin_user

    def index
      @users = User.all.includes(:tasks)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: t('flash.user_created')
      else
        render :new
      end
    end

    def show
      # 管理者用のユーザー詳細表示
      @user = User.find(params[:id])
    end

    def edit
      # 管理者用のユーザー編集
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_path, notice: t('flash.user_updated')
      else
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      if @user.admin? && User.where(admin: true).count <= 1
        redirect_to admin_users_path, alert: t('alert.delete_last_admin')
      else
        @user.destroy
        redirect_to admin_users_path, notice: t('flash.user_destroyed')
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end

    def admin_user
      unless current_user&.admin?
        flash[:alert] = t('alert.admin_access')
        redirect_to tasks_path
      end
    end
  end
end
