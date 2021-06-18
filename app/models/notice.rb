class Notice < ApplicationRecord
  belongs_to :farmer, optional: true
  belongs_to :customer, optional: true
  belongs_to :event, optional: true

  #0～2:farmer用、3～:customer用
  enum action: {
    "フォロー": 0,
    "チャット": 1,
    "予約": 2,
    "農業体験の内容更新": 3,
    "農業体験のスケジュール更新": 4,
    "お知らせ": 5,
  }
end
