# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservation, "モデルに関するテスト", type: :model do
  describe '保存チェック' do
    it "有効な情報の場合は保存されるか" do
      expect(FactoryBot.build(:reservation)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "peopleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      reservation = FactoryBot.build(:reservation)
      reservation.people = ''
      expect(reservation).to be_invalid
      expect(reservation.errors[:people]).to include("can't be blank")
    end
  end
  context "数値のバリデーションチェック" do
    it "peopleが数字で入力されているかバリデーションチェックされ、数字のエラーメッセージが返ってきているか" do
      reservation = FactoryBot.build(:reservation)
      reservation.people = 'hoge'
      expect(reservation).to be_invalid
      expect(reservation.errors[:people]).to include("is not a number")
    end
    it "peopleが1以上で入力されているかバリデーションチェックされ、数字のエラーメッセージが返ってきているか" do
      reservation = FactoryBot.build(:reservation)
      reservation.people = 0
      expect(reservation).to be_invalid
      expect(reservation.errors[:people]).to include("must be greater than or equal to 1")
    end
  end
end
