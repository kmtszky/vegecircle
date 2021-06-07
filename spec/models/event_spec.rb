# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, "モデルに関するテスト", type: :model do
  describe '保存チェック' do
    it "有効な情報の場合は保存されるか" do
      expect(FactoryBot.build(:event)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "titleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.title = ''
      expect(event).to be_invalid
      expect(event.errors[:title]).to include("can't be blank")
    end
    it "plan_image_idが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.plan_image_id = ''
      expect(event).to be_invalid
      expect(event.errors[:plan_image]).to include("can't be blank")
    end
    it "bodyが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.body = ''
      expect(event).to be_invalid
      expect(event.errors[:body]).to include("can't be blank")
    end
    it "feeが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.fee = ''
      expect(event).to be_invalid
      expect(event.errors[:fee]).to include("can't be blank")
    end
    it "cancel_changeが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.cancel_change = ''
      expect(event).to be_invalid
      expect(event.errors[:cancel_change]).to include("can't be blank")
    end
    it "locationが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.location = ''
      expect(event).to be_invalid
      expect(event.errors[:location]).to include("can't be blank")
    end
    it "accessが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.access = ''
      expect(event).to be_invalid
      expect(event.errors[:access]).to include("can't be blank")
    end
    it "start_dateが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.start_date = ''
      expect(event).to be_invalid
      expect(event.errors[:start_date]).to include("can't be blank")
    end
    it "end_dateが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.end_date = ''
      expect(event).to be_invalid
      expect(event.errors[:end_date]).to include("can't be blank")
    end
    it "start_timeが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.start_time = ''
      expect(event).to be_invalid
      expect(event.errors[:start_time]).to include("can't be blank")
    end
    it "end_timeが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.end_time = ''
      expect(event).to be_invalid
      expect(event.errors[:end_time]).to include("can't be blank")
    end
    it "number_of_participantsが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.number_of_participants = ''
      expect(event).to be_invalid
      expect(event.errors[:number_of_participants]).to include("can't be blank")
    end
  end
  context "属性に数値のみが使われているバリデーションチェック" do
    it "feeが数字で入力されているかバリデーションチェックされ、数字のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.fee = 'hoge'
      expect(event).to be_invalid
      expect(event.errors[:fee]).to include("is not a number")
    end
    it "number_of_participantsが数字で入力されているかバリデーションチェックされ、数字のエラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.number_of_participants = 'hoge'
      expect(event).to be_invalid
      expect(event.errors[:number_of_participants]).to include("is not a number")
    end
  end
  context "日程・日時のバリデーションチェック" do
    it "start_dateがevent作成日翌日以降でない場合、エラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.start_date = Date.current - 1
      expect(event).to be_invalid
      expect(event.errors[:start_date]).to include("は本日以降の日付を選択してください")
    end
    it "end_dateがevent作成日翌日以降でない場合、エラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.end_date = Date.current - 1
      expect(event).to be_invalid
      expect(event.errors[:end_date]).to include("は本日以降の日付を選択してください")
    end
    it "start_dateがend_dateよりも前の日である場合、エラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.end_date = event.start_date - 1
      expect(event).to be_invalid
      expect(event.errors[:end_date]).to include("は開始日以降の日付を選択してください")
    end
    it "end_timeがstart_timeと比べ同刻または早い時刻である場合、エラーメッセージが返ってきているか" do
      event = FactoryBot.build(:event)
      event.end_time = event.start_time - 60*60*1
      expect(event).to be_invalid
      expect(event.errors[:end_time]).to include("は開始時刻よりも後の時刻を選択してください")
    end
  end
end
