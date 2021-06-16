require 'rails_helper'

describe '[step3] Farmer ログイン後のテスト' do
  let(:farmer) { create(:farmer) }

  before do
    visit new_farmer_session_path
    fill_in 'farmer[email]', with: farmer.email
    fill_in 'farmer[password]', with: farmer.password
    click_button 'ログイン'
  end

  describe 'マイページのテスト' do
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/farmers/' + farmer.id.to_s
      end
      it '農家の名前・直売所の住所・農家の所在エリアが表示される' do
        expect(page).to have_content farmer.name
        expect(page).to have_content farmer.farm_address
        expect(page).to have_content farmer.store_address
      end
      it '自農家の編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_farmers_farmer_path(farmer)
      end
    end

    context 'お知らせフォームの確認' do
      it 'news投稿用フォームが表示される' do
        expect(page).to have_field 'news[news]'
      end
      it 'news投稿用フォームに値が入っていない' do
        expect(find_field('news[news]').text).to be_blank
      end
      it 'news画像投稿ボタンが表示される' do
        expect(page).to have_field 'news[news_image]'
      end
      it 'お知らせの投稿ボタンが表示される' do
        expect(page).to have_button '送信'
      end
    end

    context 'お知らせ投稿・削除機能の確認' do
      before do
        fill_in 'news[news]', with: Faker::Lorem.characters(number: 10)
      end

      it '新しいお知らせが正しく保存される' do
        expect { click_button '送信' }.to change(farmer.news, :count).by(1)
      end
      it '投稿：サクセスメッセージが表示される' do
        click_button '送信'
        expect(page).to have_content 'お知らせを投稿しました'
      end
      it '投稿すると削除ボタンが表示される' do
        click_button '送信'
        expect(page).to have_content farmer.news.last.news
        expect(page).to have_link '削除'
      end
    end

    context 'お知らせ一覧の確認' do
      it 'ニュースの内容が降順で表示されているか、都度削除ボタンが表示されているか' do
        (1..4).each do |i|
          News.create(news: 'hoge'+i.to_s, farmer_id: farmer.id)
        end
        visit farmers_farmer_path(farmer)
        News.where(farmer_id: farmer.id).each_with_index do |news, n|
          i = 4 - n
          expect(page).to have_content news.news
          # Destroyリンク
          destroy_link = find_all('a')[n+6]
          break if n == 3
          expect(destroy_link[:href]).to eq farmers_news_path("#{i}")
        end
        expect(page).to have_content '全てのお知らせを表示'
      end
    end

    context 'お知らせ投稿失敗の確認' do
      before do
        fill_in 'news[news]', with: ''
        click_button '送信'
      end

      it 'エラーメッセージが表示されるか' do
        expect(page).to have_content "can't be blank"
      end
    end
  end

  describe '自農家の編集画面のテスト' do
    before do
      visit edit_farmers_farmer_path(farmer)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/farmers/' + farmer.id.to_s + '/edit'
      end
      it '農家名編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'farmer[name]', with: farmer.name
      end
      it '農家画像編集フォームが表示される' do
        expect(page).to have_field 'farmer[farmer_image]'
      end
      it '農家エリア編集フォームに農家エリアが表示される' do
        expect(page).to have_field 'farmer[farm_address]', with: farmer.farm_address
      end
      it '直売所住所編集フォームに直売所住所が表示される' do
        expect(page).to have_field 'farmer[store_address]', with: farmer.store_address
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'farmer[introduction]', with: farmer.introduction
      end
      it '農家紹介画像フォームが表示される' do
        expect(page).to have_field 'farmer[image_1]'
        expect(page).to have_field 'farmer[image_2]'
        expect(page).to have_field 'farmer[image_3]'
      end
      it '「退会する」ボタンが表示される' do
        expect(page).to have_link '退会する', href: farmers_farmers_unsubscribe_path(farmer)
      end
      it '「変更を保存」ボタンが表示される' do
        expect(page).to have_button '変更を保存'
      end
    end

    context '更新成功のテスト' do
      before do
        @farmer_old_name = farmer.name
        fill_in 'farmer[name]', with: Faker::Lorem.characters(number: 5)
        fill_in 'farmer[introduction]', with: Faker::Lorem.characters(number: 10)
        click_button '変更を保存'
      end

      it '変更内容が正しく更新される' do
        expect(farmer.reload.name).not_to eq @farmer_old_name
      end
      it '新規追加事項（null: true）が正しく保存される' do
        expect(farmer.introduction).not_to eq ''
      end
      it 'リダイレクト先がマイページである' do
        expect(current_path).to eq '/farmers/farmers/' + farmer.id.to_s
      end
      it 'サクセスメッセージが表示される' do
        expect(page).to have_content '更新しました'
      end
    end

    context '更新失敗のテスト' do
      before do
        fill_in 'farmer[name]', with: ''
        click_button '変更を保存'
      end

      it '編集画面から遷移しない' do
        expect(current_path).to eq '/farmers/farmers/' + farmer.id.to_s
      end
      it 'エラーメッセージが表示される' do
        expect(page).to have_content "can't be blank"
      end
    end

  end

  describe '退会機能のテスト' do
    before do
      visit edit_farmers_farmer_path(farmer)
      click_link '退会する'
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/farmers/' + farmer.id.to_s + '/unsubscribe'
      end
      it '「退会しない」ボタンが表示され、リンク先が適切である' do
        expect(page).to have_link '退会しない', href: farmers_farmer_path(farmer)
      end
      it '「退会する」ボタンが表示され、リンク先が適切である' do
        expect(page).to have_link '退会する', href: farmers_farmers_withdraw_path(farmer)
      end
    end

    context '退会可能か確認' do
      it '退会ボタンを押して、リダイレクト先がトップ画面である' do
        click_link '退会する'
        expect(current_path).to eq '/'
      end
      it 'サクセスメッセージが表示される' do
        click_link '退会する'
        expect(page).to have_content '退会処理が完了しました。またのご利用を心よりお待ちしております！'
      end
    end
  end
end