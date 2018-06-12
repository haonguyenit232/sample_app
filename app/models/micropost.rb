class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.max_content}
  validate  :picture_size
  mount_uploader :picture, PictureUploader
  scope :newest, ->{order(created_at: :desc)}

  private

  def picture_size
    return unless picture.size > Settings.img_size.megabytes
    errors.add :picture, I18n.t("microposts.size_notice")
  end
end
