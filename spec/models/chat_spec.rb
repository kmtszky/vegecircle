# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chat, "モデルに関するテスト", type: :model do
  describe '保存チェック' do
    it "有効な情報の場合は保存されるか" do
      expect(FactoryBot.build(:chat)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "chatが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      chat = Chat.new(chat: '', farmer_id: 1)
      expect(chat).to be_invalid
      expect(chat.errors[:chat]).to include("can't be blank")
    end
  end
end
