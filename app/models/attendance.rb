class Attendance < ApplicationRecord
  # Userモデルと1対1の関係を示す
  # ruby:AttendanceモデルがUserモデルに対して、1対1の関連性を示すコード
  belongs_to :user
  
  # どの日付の勤怠情報かを判断する上で必須
  validates :worked_on, presence: true
  # 一言メモのような用途
  validates :note, length: { maximum: 50 }
  
  
   # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at

  def finished_at_is_invalid_without_a_started_at
    # blank?は対象がnil "" " " [] {}のいずれかでtrueを返します。present?はその逆（値が存在する場合）にtrueを返します。
    # 出勤時間が無い、かつ退勤時間が存在する場合
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
end
