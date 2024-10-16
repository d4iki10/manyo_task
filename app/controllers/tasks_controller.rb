class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # タスク一覧画面（Read）
  def index
    @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
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
    params.require(:task).permit(:title, :content)
  end

  # 共通処理：@taskのセット
  def set_task
    @task = Task.find(params[:id])
  end
end
