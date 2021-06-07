# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な情報の場合は保存されるか" do
      expect(FactoryBot.build(:customer)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "nicknameが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      customer = Customer.new(nickname: '', email:'hoge@hoge', password:'password')
      expect(customer).to be_invalid
      expect(customer.errors[:nickname]).to include("can't be blank")
    end
  end
end