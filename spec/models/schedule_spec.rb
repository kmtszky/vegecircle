# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schedule, "モデルに関するテスト", type: :model do
  describe '保存チェック' do
    it "有効な情報の場合は保存されるか" do
      expect(FactoryBot.build(:schedule)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "dateが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      schedule = FactoryBot.build(:schedule)
      schedule.date = ''
      expect(schedule).to be_invalid
      expect(schedule.errors[:date]).to include("can't be blank")
    end
    it "start_timeが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      schedule = FactoryBot.build(:schedule)
      schedule.start_time = ''
      expect(schedule).to be_invalid
      expect(schedule.errors[:start_time]).to include("can't be blank")
    end
    it "end_timeが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      schedule = FactoryBot.build(:schedule)
      schedule.end_time = ''
      expect(schedule).to be_invalid
      expect(schedule.errors[:end_time]).to include("can't be blank")
    end
    it "peopleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      schedule = FactoryBot.build(:schedule)
      schedule.people = ''
      expect(schedule).to be_invalid
      expect(schedule.errors[:people]).to include("can't be blank")
    end
  end
  context "数値のバリデーションチェック" do
    it "peopleが数字で入力されているかバリデーションチェックされ、数字のエラーメッセージが返ってきているか" do
      schedule = FactoryBot.build(:schedule)
      schedule.people = 'hoge'
      expect(schedule).to be_invalid
      expect(schedule.errors[:people]).to include("is not a number")
    end
    it "peopleが1以上で入力されているかバリデーションチェックされ、数字のエラーメッセージが返ってきているか" do
      schedule = FactoryBot.build(:schedule)
      schedule.people = 0
      expect(schedule).to be_invalid
      expect(schedule.errors[:people]).to include("must be greater than or equal to 1")
    end
  end
  context "日時のバリデーションチェック" do
    it "dateがschedule編集日翌日以降でない場合、エラーメッセージが返ってきているか" do
      schedule = FactoryBot.build(:schedule)
      schedule.date = Date.current - 1
      expect(schedule).to be_invalid
      expect(schedule.errors[:date]).to include("は本日以降の日付を選択してください")
    end
    it "end_timeがstart_timeと比べ同刻または早い時刻である場合、エラーメッセージが返ってきているか" do
      schedule = FactoryBot.build(:schedule)
      schedule.end_time = schedule.start_time - 60*60*1
      expect(schedule).to be_invalid
      expect(schedule.errors[:end_time]).to include("は開始時刻よりも後の時刻を選択してください")
    end
  end
end
