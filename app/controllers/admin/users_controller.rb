# app/controllers/admin/users_controller.rb
module Admin
  class UsersController < ApplicationController
    before_action :require_admin
    before_action :set_user, only: [:show, :edit, :update, :destroy]

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

    def index
      @users = User.all
    end

    def show
      # 管理者用のユーザー詳細表示
    end

    def edit
      # 管理者用のユーザー編集
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: I18n.t('flash.update_success', model: I18n.t('activerecord.models.user'))
      else
        render :edit
      end
    end

    def destroy
      if @user.admin? && User.where(admin: true).count <= 1
        redirect_to admin_users_path, alert: I18n.t('flash.delete_last_admin')
      else
        @user.destroy
        redirect_to admin_users_path, notice: I18n.t('flash.destroy_success', model: I18n.t('activerecord.models.user'))
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end

    def require_admin
      unless current_user&.admin?
        redirect_to tasks_path, alert: I18n.t('flash.alert.admin_access')
      end
    end
  end
end
