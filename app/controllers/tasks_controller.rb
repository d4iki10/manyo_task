class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

  # タスク一覧画面（Read）
  def index
    @tasks = current_user.admin? ? Task.includes(:user).all : current_user.tasks

    # 検索機能の実装
    if params[:search].present?
      @tasks = @tasks.search_title(params[:search][:title]) if params[:search][:title].present?
      @tasks = @tasks.search_status(params[:search][:status]) if params[:search][:status].present?
    end

    # ソート機能の実装
    if params[:sorted_deadline_on].present?
      @tasks = @tasks.sorted_by_deadline
    elsif params[:sorted_priority].present?
      @tasks = @tasks.sorted_by_priority
    else
      @tasks = @tasks.order(created_at: :desc)
    end

    @tasks = @tasks.page(params[:page]).per(10)
  end

  # タスク詳細画面（Read）
  def show
  end

  # タスク登録画面の表示（Create）
  def new
    @task = Task.new
  end

  # タスクの登録処理（Create）
  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: t('flash.create_success', model: Task.model_name.human)
    else
      flash.now[:alert] = 'タスクの作成に失敗しました。'
      render :new
    end
  end

  # タスク編集画面の表示（Update）
  def edit
  end

  # タスクの更新処理（Update）
  def update
    if @task.update(task_params)
      redirect_to @task, notice: t('flash.update_success', model: Task.model_name.human)
    else
      render :edit
    end
  end

  # タスクの削除処理（Delete）
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: t('flash.destroy_success', model: Task.model_name.human)
  end

  private

  # Strong Parametersの設定
  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end

  # 共通処理：@taskのセット
  def set_task
    @task = Task.find(params[:id])
  end

  def authorize_user
    unless current_user.admin? || @task.user == current_user
      redirect_to tasks_path, alert: 'アクセス権限がありません'
    end
  end
end
