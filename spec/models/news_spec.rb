# frozen_string_literal: true

require 'rails_helper'

RSpec.describe News, "モデルに関するテスト", type: :model do
  describe '保存チェック' do
    it "有効な情報の場合は保存されるか" do
      expect(FactoryBot.build(:news)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "newsが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      news = News.new(news: '', farmer_id:1)
      expect(news).to be_invalid
      expect(news.errors[:news]).to include("can't be blank")
    end
  end
end
