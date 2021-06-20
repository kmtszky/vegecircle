require 'rails_helper'

describe '[step3] Farmer ログイン後のテスト' do
  let(:farmer) { create(:farmer) }
  let!(:other_farmer) { create(:farmer) }
  let!(:event) { create(:event, farmer: farmer) }
  let!(:other_event) { create(:event, farmer: other_farmer) }
  let!(:recipe) { create(:recipe, farmer: farmer) }
  let!(:other_recipe) { create(:recipe, farmer: other_farmer) }

  before do
    visit new_farmer_session_path
    fill_in 'farmer[email]', with: farmer.email
    fill_in 'farmer[password]', with: farmer.password
    click_button 'ログイン'
  end

  describe 'マイページのテスト' do
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/farmers'
      end
      it '自分の名前・直売所の住所・農家の所在エリアが表示される' do
        expect(page).to have_content farmer.name
        expect(page).to have_content farmer.farm_address
        expect(page).to have_content farmer.store_address
      end
      it '自分の編集画面へのリンクが存在する' do
        expect(page).to have_link "編集する", href: edit_farmers_farmers_path
      end
      it '自分の投稿へのリンクが表示される' do
        expect(page).to have_link event.title, href: farmers_event_path(event)
        expect(page).to have_link recipe.title, href: farmers_recipe_path(recipe)
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link other_event.title, href: farmers_event_path(other_event)
        expect(page).not_to have_link other_recipe.title, href: farmers_recipe_path(other_recipe)
      end
    end
  end

  describe 'お知らせ機能のテスト' do
    context 'フォームの表示内容の確認' do
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

    context '投稿・削除機能の確認' do
      before do
        fill_in 'news[news]', with: Faker::Lorem.characters(number: 10)
      end

      it '新しいお知らせが正しく保存される' do
        expect { click_button '送信' }.to change(farmer.news, :count).by(1)
      end
      it '投稿成功時：サクセスメッセージが表示される' do
        click_button '送信'
        expect(page).to have_content 'お知らせを投稿しました'
      end
      it '投稿成功時：削除ボタンが表示される' do
        click_button '送信'
        expect(page).to have_content farmer.news.last.news
        expect(page).to have_link '削除'
      end
      #削除機能はajaxであるため確認なし
    end

    context '一覧の確認' do
      it 'ニュースの内容が降順で表示されているか、都度削除ボタンが表示されているか' do
        (1..4).each do |i|
          News.create(news: 'hoge'+i.to_s, farmer_id: farmer.id)
        end
        visit farmers_farmers_path
        News.where(farmer_id: farmer.id).each_with_index do |news, n|
          i = 4 - n
          expect(page).to have_content news.news
          # Destroyリンク
          destroy_link = find_all('a')[n+7]
          break if n == 3
          expect(destroy_link[:href]).to eq farmers_news_path("#{i}")
        end
        expect(page).to have_content '全てのお知らせを表示'
      end
    end

    context '投稿失敗の確認' do
      before do
        fill_in 'news[news]', with: ''
        click_button '送信'
      end

      it 'エラーメッセージが表示されるか' do
        expect(page).to have_content "can't be blank"
      end
    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_farmers_farmers_path
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/farmers/edit'
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
        expect(page).to have_link '退会する', href: farmers_farmers_unsubscribe_path
      end
      it '「変更を保存」ボタンが表示される' do
        expect(page).to have_button '変更を保存'
      end
    end

    context '更新成功時' do
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
        expect(current_path).to eq '/farmers/farmers'
      end
      it 'サクセスメッセージが表示される' do
        expect(page).to have_content '更新しました'
      end
    end

    context '更新失敗時' do
      before do
        fill_in 'farmer[name]', with: ''
        click_button '変更を保存'
      end

      it '編集画面から遷移しない' do
        expect(current_path).to eq '/farmers/farmers'
      end
      it 'エラーメッセージが表示される' do
        expect(page).to have_content "can't be blank"
      end
    end
  end

  describe '退会機能のテスト' do
    before do
      visit edit_farmers_farmers_path
      click_link '退会する'
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/farmers/unsubscribe'
      end
      it '「退会しない」ボタンが表示され、リンク先が適切である' do
        expect(page).to have_link '退会しない', href: farmers_farmers_path
      end
      it '「退会する」ボタンが表示され、リンク先が適切である' do
        expect(page).to have_link '退会する', href: farmers_farmers_withdraw_path
      end
    end

    context '退会可能か確認' do
      it '退会ボタンを押して、リダイレクト先がトップ画面である' do
        click_link '退会する'
        expect(current_path).to eq '/farmers/sign_in'
      end
      it 'サクセスメッセージが表示される' do
        click_link '退会する'
        expect(page).to have_content '退会処理が完了しました。またのご利用を心よりお待ちしております'
      end
    end
  end
end