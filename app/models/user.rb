class User < ApplicationRecord
  has_secure_password

  before_validation { email&.downcase! }
  before_update :ensure_admin_exists_on_update, if: :will_save_change_to_admin?
  before_destroy :ensure_admin_exists_on_destroy

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false, message: 'メールアドレスはすでに使用されています' }
  validates :password, presence: true, length: { minimum: 6 }

  private

  def ensure_admin_exists_on_update
    if self.admin_was && !self.admin && User.where(admin: true).count <= 1
      errors.add(:base, '管理者が0人になるため権限を変更できません')
      throw(:abort)
    end
  end

  def ensure_admin_exists_on_destroy
    if self.admin? && User.where(admin: true).count <= 1
      errors.add(:base, '管理者が0人になるため削除できません')
      throw(:abort)
    end
  end
end
