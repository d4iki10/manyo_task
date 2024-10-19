# app/controllers/admin/users_controller.rb
module Admin
  class UsersController < ApplicationController
    before_action :admin_user
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      @users = User.all.includes(:tasks)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: I18n.t('flash.create_success', model: I18n.t('activerecord.models.user'))
      else
        render :new
      end
    end

    def show
      # 管理者用のユーザー詳細表示
    end

    def edit
      # 管理者用のユーザー編集
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: t('flash.update_success', model: t('activerecord.models.user'))
      else
        render :edit
      end
    end

    def destroy
      if @user.admin? && User.where(admin: true).count <= 1
        redirect_to admin_users_path, alert: t('flash.delete_last_admin')
      else
        @user.destroy
        redirect_to admin_users_path, notice: t('flash.destroy_success', model: t('activerecord.models.user'))
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end

    def admin_user
      unless current_user&.admin?
        flash[:alert] = t('flash.alert.admin_access')
        redirect_to tasks_path
      end
    end
  end
end
