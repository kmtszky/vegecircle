require 'rails_helper'

describe '[step2-1] Farmer ログイン・ログアウトのテスト' do
  describe 'farmer：新規登録のテスト' do
    before do
      visit new_farmer_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/sign_up'
      end
      it '「新規登録」と表示される' do
        expect(page).to have_content '新規登録'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'farmer[name]'
      end
      it 'farm_addressフォームが表示される' do
        expect(page).to have_field 'farmer[farm_address]'
      end
      it 'store_addressフォームが表示される' do
        expect(page).to have_field 'farmer[store_address]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'farmer[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'farmer[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'farmer[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'farmer[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'farmer[store_address]', with: Faker::Lorem.characters(number: 10)
        fill_in 'farmer[farm_address]', with: Faker::Address.full_address
        fill_in 'farmer[email]', with: Faker::Internet.email
        fill_in 'farmer[password]', with: 'password'
        fill_in 'farmer[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(Farmer.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to have_content '/farmers/' + Farmer.last.id.to_s
      end
    end
  end

  describe 'farmer：ログイン機能のテスト' do
    let(:farmer) { create(:farmer) }

    before do
      visit new_farmer_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'farmer[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'farmer[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'farmer[email]', with: farmer.email
        fill_in 'farmer[password]', with: farmer.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to have_content '/farmers/' + Farmer.last.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'farmer[email]', with: ''
        fill_in 'farmer[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/farmers/sign_in'
      end
    end
  end
end