class User < ApplicationRecord
  has_secure_password

  before_validation { email.downcase! }
  # 管理者が一人以上存在することを保証
  before_update :ensure_admin_exists, if: :will_save_change_to_admin?
  before_destroy :ensure_admin_exists

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false, message: 'メールアドレスはすでに使用されています' }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :password_confirmation, presence: true, if: -> { password.present? }
  validate :password_match, if: -> { password.present? }

  private

  def password_match
    errors.add(:password_confirmation, :confirmation) if password != password_confirmation
  end

  def ensure_admin_exists
    if self.admin_was && !self.admin && User.where(admin: true).count <= 1
      errors.add(:base, '管理者が0人になるため権限を変更できません')
      throw(:abort)
    elsif self.admin? && User.where(admin: true).count <= 1
      errors.add(:base, '管理者が0人になるため削除できません')
      throw(:abort)
    end
  end
end
