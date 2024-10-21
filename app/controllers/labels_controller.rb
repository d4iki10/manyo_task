class LabelsController < ApplicationController
  before_action :set_label, only: [:edit, :update, :destroy]
  before_action :login_required

  def index
    @labels = current_user.labels
  end

  def new
    @label = current_user.labels.new
  end

  def create
    @label = current_user.labels.new(label_params)
    if @label.save
      flash[:notice] = 'ラベルを登録しました'
      redirect_to labels_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      flash[:notice] = 'ラベルを更新しました'
      redirect_to labels_path
    else
      render :edit
    end
  end

  def destroy
    @label.destroy
    flash[:notice] = 'ラベルを削除しました'
    redirect_to labels_path
  end

  private

  def set_label
    @label = current_user.labels.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name)
  end
end
