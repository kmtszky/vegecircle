require 'rails_helper'

describe '[step3-2] Customer ログイン後のテスト' do
  let!(:customer) { create(:customer) }
  let!(:other_customer) { create(:customer) }
  let!(:farmer) { create(:farmer) }
  let!(:event) { create(:event, :with_schedules, farmer: farmer) }
  let!(:recipe) { create(:recipe, :with_tag_lists, farmer: farmer) }

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

  describe '農業体験画面のテスト' do
    before do
      visit event_path(event)
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s
      end
      it 'お気に入り件数が表示される' do
        expect(page).to have_content event.event_favorites.size
      end
      it 'イベント名・イベント概要・開催時刻・参加費・キャンセルポリシー・そのほかが表示される' do
        expect(page).to have_content event.title
        expect(page).to have_content event.body
        expect(page).to have_content event.schedules.first.start_time.strftime('%H:%M')
        expect(page).to have_content event.schedules.first.end_time.strftime('%H:%M')
        expect(page).to have_content event.fee
        expect(page).to have_content event.cancel_change
        expect(page).to have_content event.etc
      end
      it '集合場所・アクセス方法・駐車場が表示される' do
        expect(page).to have_content event.location
        expect(page).to have_content event.access
        expect(page).to have_content event.parking
      end
      it '農業体験の日程が表示され、クリックするとスケジュール詳細画面へ遷移する' do
        expect(page).to have_content "ご予約の際は、以下より希望の日程をお選びください。"
        expect(page).to have_content event.schedules.first.date.strftime('%Y/%m/%d')
        click_link event.schedules.first.date.strftime('%Y/%m/%d')
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s
      end
      it '「チャット」ボタンを押すと、ページ内のチャットフォームまで移動する' do
        expect(page).to have_link "チャット", href: "#chat"
        click_link "チャット"
        expect(current_path).to eq '/events/' + event.id.to_s
      end
    end

    context "チャット投稿用フォームの表示内容の確認" do
      it 'チャット投稿用の空フォームが表示される' do
        expect(page).to have_field 'chat[chat]'
        expect(find_field('chat[chat]').text).to be_blank
      end
      it 'チャットの投稿ボタンが表示される' do
        expect(page).to have_button '送信'
      end
    end
    #チャットの投稿機能はjavascriptのため飛ばす
  end

  describe '農業体験のスケジュール画面のテスト' do
    before do
      visit event_schedule_path(event, event.schedules.first)
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s
      end
      it 'お気に入り件数・予約件数が表示される' do
        expect(page).to have_content event.event_favorites.size
        expect(page).to have_content event.schedules.first.reservations.size
      end
      it 'イベント名・イベント概要・開催時刻・参加費・キャンセルポリシー・そのほかが表示される' do
        expect(page).to have_content event.title
        expect(page).to have_content event.body
        expect(page).to have_content event.schedules.first.start_time.strftime('%H:%M')
        expect(page).to have_content event.schedules.first.end_time.strftime('%H:%M')
        expect(page).to have_content event.fee
        expect(page).to have_content event.cancel_change
        expect(page).to have_content event.etc
      end
      it '集合場所・アクセス方法・駐車場が表示される' do
        expect(page).to have_content event.location
        expect(page).to have_content event.access
        expect(page).to have_content event.parking
      end
      it '農業体験画面へのリンクが存在し、クリックすると農業体験画面へ遷移する' do
        expect(page).to have_link "イベントページへ戻る", href: event_path(event)
        click_link "イベントページへ戻る"
        expect(current_path).to eq '/events/' + event.id.to_s
      end
      it '農業体験画面を予約するリンクが存在し、クリックすると農業体験予約画面へ遷移する' do
        expect(page).to have_link "予約する", href: new_event_schedule_reservation_path(event, event.schedules.first)
        click_link "予約する"
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s + '/reservations/new'
      end
    end
  end
end