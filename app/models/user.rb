class User < ApplicationRecord
  before_validation { email.downcase! }

  has_secure_password

  has_many :tasks, dependent: :destroy
  
  validates :name, presence: { message: 'を入力してください' }
  validates :email, presence: { message: 'を入力してください' },
                    uniqueness: { case_sensitive: false, message: 'はすでに使用されています' }
  validates :password, presence: { message: 'を入力してください' },
                       length: { minimum: 6, message: 'は6文字以上で入力してください' },
                       allow_nil: true
  validates :password_confirmation, presence: { message: 'とパスワードの入力が一致しません' },
                                    if: -> { password.present? }

  # 管理者が一人以上存在することを保証
  before_update :ensure_admin_exists, if: :will_save_change_to_admin?
  before_destroy :ensure_admin_exists

  private

  def ensure_admin_exists
    if User.where(admin: true).count <= 1 && (admin_changed? ? admin == false : true)
      errors.add(:base, '管理者が0人になるため削除できません')
      throw(:abort)
    end
  end
end
