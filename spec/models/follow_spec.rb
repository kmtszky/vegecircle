# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Follow, "モデルに関するテスト", type: :model do
  describe '保存チェック' do
    it "有効な情報の場合は保存されるか" do
      expect(FactoryBot.build(:follow)).to be_valid
    end
  end
end
