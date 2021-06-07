# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Evaluation, "モデルに関するテスト", type: :model do
  describe '保存チェック' do
    it "有効な情報の場合は保存されるか" do
      expect(FactoryBot.build(:evaluation)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "evaluationとcommentが空白の場合に空白のエラーメッセージが返ってきているか" do
      evaluation = FactoryBot.build(:evaluation)
      evaluation.evaluation = ''
      evaluation.comment = ''
      expect(evaluation).to be_invalid
      expect(evaluation.errors[:evaluation]).to include("can't be blank")
      expect(evaluation.errors[:comment]).to include("can't be blank")
    end
    it "evaluationとcommentのうちevaluationが空白の場合に、エラーメッセージが返ってこない" do
      evaluation = FactoryBot.build(:evaluation)
      evaluation.evaluation = ''
      expect(evaluation).to be_valid
    end
    it "evaluationとcommentのうちcommentが空白の場合に、エラーメッセージが返ってこない" do
      evaluation = FactoryBot.build(:evaluation)
      evaluation.comment = ''
      expect(evaluation).to be_valid
  end
  end
end
