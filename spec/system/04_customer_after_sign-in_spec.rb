require 'rails_helper'

describe '[step3-2] Customer ログイン後のテスト' do
  let(:customer) { create(:customer) }
  let!(:other_customer) { create(:customer) }

  before do
    visit new_customer_session_path
    fill_in 'customer[email]', with: customer.email
    fill_in 'customer[password]', with: customer.password
    click_button 'ログイン'
  end

  describe 'マイページのテスト' do
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/profiles'
      end
      it '自分の名前・メールアドレスが表示される' do
        expect(page).to have_content customer.nickname
        expect(page).to have_content customer.email
      end
      it '自分の編集画面へのリンクが存在する' do
        expect(page).to have_link "編集する", href: edit_profiles_path
      end
      it 'フォロー・お気に入り・レビュー一覧へのリンクが表示される' do
        expect(page).to have_link "フォロー", href: followings_path
        expect(page).to have_link "お気に入り", href: favorites_path
        expect(page).to have_link "レビュー", href: evaluations_path
      end
      it '他人の情報は表示されない' do
        expect(page).not_to have_content other_customer.nickname
        expect(page).not_to have_content other_customer.email
      end
    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_profiles_path
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/profiles/edit'
      end
      it '住民名編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'customer[nickname]', with: customer.nickname
      end
      it '住民画像編集フォームが表示される' do
        expect(page).to have_field 'customer[customer_image]'
      end
      it '「変更を保存」ボタンが表示される' do
        expect(page).to have_button '変更を保存'
      end
      it '「退会する」ボタンが表示される' do
        expect(page).to have_link '退会する', href: customer_unsubscribe_path
      end
    end

    context '更新成功時' do
      before do
        @customer_old_nickname = customer.nickname
        fill_in 'customer[nickname]', with: Faker::Lorem.characters(number: 5)
        click_button '変更を保存'
      end

      it '変更内容が正しく更新される' do
        expect(customer.reload.nickname).not_to eq @customer_old_nickname
      end
      it 'リダイレクト先がマイページである' do
        expect(current_path).to eq '/profiles'
      end
      it 'サクセスメッセージが表示される' do
        expect(page).to have_content '登録情報を更新しました'
      end
    end

    context '更新失敗時' do
      before do
        fill_in 'customer[nickname]', with: ''
        click_button '変更を保存'
      end

      it '編集画面から遷移しない' do
        expect(current_path).to eq '/profiles'
      end
      it 'エラーメッセージが表示される' do
        expect(page).to have_content "can't be blank"
      end
    end
  end

  describe '退会機能のテスト' do
    before do
      visit edit_profiles_path
      click_link '退会する'
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/customer/unsubscribe'
      end
      it '「退会しない」ボタンが表示され、リンク先が適切である' do
        expect(page).to have_link '退会しない', href: profiles_path
      end
      it '「退会する」ボタンが表示され、リンク先が適切である' do
        expect(page).to have_link '退会する', href: customer_withdraw_path
      end
    end

    context '退会可能か確認' do
      it '「退会する」ボタンを押して、リダイレクト先が登録画面である' do
        click_link '退会する'
        expect(current_path).to eq '/customers/sign_in'
      end
      it 'サクセスメッセージが表示される' do
        click_link '退会する'
        expect(page).to have_content '退会処理が完了しました。またのご利用を心よりお待ちしております'
      end
    end
  end
end