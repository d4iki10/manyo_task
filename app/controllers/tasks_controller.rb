class TasksController < ApplicationController
  before_action :login_required
  before_action :authorize_user, only: [:show, :edit]

  # タスク一覧画面（Read）
  def index
    @tasks = current_user.tasks.page(params[:page])

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
    @task = Task.find(params[:id])
  end

  # タスク登録画面の表示（Create）
  def new
    @task = Task.new
  end

  # タスクの登録処理（Create）
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:notice] = t('flash.account_created')
      redirect_to tasks_path
    else
      flash.now[:alert] = 'タスクの作成に失敗しました。'
      render :new
    end
  end

  # タスク編集画面の表示（Update）
  def edit
    @task = Task.find(params[:id])
  end

  # タスクの更新処理（Update）
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to task_path(@task), notice: t('flash.task_updated', model: Task.model_name.human)
    else
      render :edit
    end
  end

  # タスクの削除処理（Delete）
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: t('flash.task_destroyed', model: Task.model_name.human)
  end

  private

  # アクセス権限のチェック
  def authorize_user
    unless current_user.admin? || @task.user == current_user
      flash[:alert] = "アクセス権限がありません"
      redirect_to tasks_path  # タスク一覧ページにリダイレクト
    end
  end

  # Strong Parameters
  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end
end
