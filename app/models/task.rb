class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  enum priority: { low: 0, medium: 1, high: 2 }
  enum status: { not_started: 0, in_progress: 1, completed: 2 }

  # 検索スコープの定義
  scope :search_title, ->(keyword) { where('title LIKE ?', "%#{keyword}%") }
  scope :search_status, ->(status) { where(status: status) }
  # ソートスコープの定義
  scope :sorted_by_deadline, -> { order(deadline_on: :asc) }
  scope :sorted_by_priority, -> { order(priority: :desc, created_at: :desc) }

  def priority_i18n
    I18n.t("tasks.priority.#{priority}")
  end

  def status_i18n
    I18n.t("tasks.status.#{status}")
  end
end
