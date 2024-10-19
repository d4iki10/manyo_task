class TasksController < ApplicationController
  before_action :login_required
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

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
  end

  # タスクの更新処理（Update）
  def update
    if @task.update(task_params)
      redirect_to task_path(@task), notice: t('flash.update_success', model: Task.model_name.human)
    else
      render :edit
    end
  end

  # タスクの削除処理（Delete）
  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('flash.destroy_success', model: Task.model_name.human)
  end

  private

  # 共通処理：@taskのセット
  def set_task
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "タスクが見つかりません"
    redirect_to tasks_path  # タスク一覧ページにリダイレクト
  end

  # アクセス権限のチェック
  def authorize_user
    unless current_user.admin? || @task.user == current_user
      flash[:alert] = "アクセス権がありません"
      redirect_to tasks_path  # タスク一覧ページにリダイレクト
    end
  end

  # Strong Parameters
  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end
end
