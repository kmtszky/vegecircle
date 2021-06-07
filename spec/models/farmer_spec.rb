# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Farmer, "モデルに関するテスト", type: :model do
  describe '保存チェック' do
    it "有効な情報の場合は保存されるか" do
      expect(FactoryBot.build(:farmer)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "nameが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      farmer = Farmer.new(name: '', email: 'hoge@hoge', password: 'password', store_address: 'storeadd', farm_address: 'farmadd')
      expect(farmer).to be_invalid
      expect(farmer.errors[:name]).to include("can't be blank")
    end
    it "store_addressが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      farmer = Farmer.new(name: 'hoge', email: 'hoge@hoge', password: 'password', store_address: '', farm_address: 'farmadd')
      expect(farmer).to be_invalid
      expect(farmer.errors[:store_address]).to include("can't be blank")
    end
    it "farm_addressが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      farmer = Farmer.new(name: 'hoge', email: 'hoge@hoge', password: 'password', store_address: 'storeadd', farm_address: '')
      expect(farmer).to be_invalid
      expect(farmer.errors[:farm_address]).to include("can't be blank")
    end
  end
end