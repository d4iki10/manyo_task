class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # タスク一覧画面（Read）
  def index
    @tasks = Task.all
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
      redirect_to tasks_path, notice: 'Task was successfully created.'
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
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  # タスクの削除処理（Delete）
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
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
