require 'rails_helper'

describe '[step3-1] Farmer ログイン後のテスト' do
  let(:farmer) { create(:farmer) }
  let!(:other_farmer) { create(:farmer) }

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
      it '自分の名前・メールアドレス・フォロワー数が表示される' do
        expect(page).to have_content farmer.name
        expect(page).to have_content farmer.email
        expect(page).to have_content farmer.evaluations.size
      end
      it '自分の編集画面へのリンクが存在する' do
        expect(page).to have_link "基本情報の編集", href: edit_farmers_farmers_path
      end
      it 'プレビューリンクが存在し、クリックするとプレビューページへ遷移する' do
        expect(page).to have_link '', href: farmer_path(farmer)
        find_all("a")[7].click
        expect(current_path).to eq '/farmers/evaluations'
        expect(page).to have_content "レビュー一覧"
      end
      it '自分の評価一覧へのリンクが存在し、クリックすると一覧ページへ遷移する' do
        expect(page).to have_link farmer.evaluations.size, href: farmers_farmers_evaluations_path
        click_link farmer.evaluations.size
        expect(current_path).to eq '/farmers/evaluations'
      end
      it '他人の情報は表示されない' do
        expect(page).not_to have_content other_farmer.name
      end
    end
  end

  describe 'お知らせ機能のテスト' do
    context 'フォームの表示内容の確認' do
      it 'news投稿用の空フォームが表示される' do
        expect(page).to have_field 'news[news]'
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
      it 'ニュースの内容が降順で表示され、都度削除ボタンが表示されているか。3件以上で「全てのお知らせを表示」ボタンが出るか' do
        (1..4).each do |i|
          News.create(news: 'hoge'+i.to_s, farmer_id: farmer.id)
        end
        visit farmers_farmers_path
        News.where(farmer_id: farmer.id).each_with_index do |news, n|
          i = 4 - n
          expect(page).to have_content news.news
          # Destroyリンク
          destroy_link = find_all('a')[n+9]
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
      it '「退会する」ボタンを押して、リダイレクト先が登録画面である' do
        click_link '退会する'
        expect(current_path).to eq '/farmers/sign_in'
      end
      it 'サクセスメッセージが表示される' do
        click_link '退会する'
        expect(page).to have_content '退会処理が完了しました。またのご利用を心よりお待ちしております'
      end
    end
  end

  describe '農業体験・予約一覧のテスト' do
    let(:event) { create(:event, :with_schedules, farmer: farmer) }
    let!(:other_event) { create(:event, :with_schedules, farmer: other_farmer) }

    before do
      visit farmers_farmers_calender_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/calender'
      end
      it 'タイトルが表示される' do
        expect(page).to have_content "農業体験・予約一覧"
      end
      it '今月のカレンダーが表示される' do
        expect(page).to have_content Date.current.strftime('%Y年 %-m月')
      end
      it '農業体験の作成画面へのリンクが存在し、クリックすると農業体験作成画面へ遷移する' do
        expect(page).to have_link "農業体験を作成する", href: new_farmers_event_path
        click_link "農業体験を作成する"
        expect(current_path).to eq '/farmers/events/new'
      end
      it '農業体験一覧画面へのリンクが存在し、クリックすると農業体験一覧画面へ遷移する' do
        expect(page).to have_link "一覧表示に切り替え", href: farmers_events_path
        click_link "一覧表示に切り替え"
        expect(current_path).to eq '/farmers/events'
      end
      it '自分の農業体験の名前・予約可能人数・開始時刻が表示される' do
        expect(page).to have_content event.title
        expect(page).to have_content event.schedules.start_time
        expect(page).to have_content event.schedules.people
      end
      it '他人の農業体験は表示されない' do
        expect(page).not_to have_content other_event.title
      end
    end
  end

  describe '農業体験作成画面のテスト' do
    before do
      visit new_farmers_event_path
    end

    context 'フォームの表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/events/new'
      end
      it 'タイトルが表示される' do
        expect(page).to have_content "農業体験イベントの作成"
      end
      it '「イベント概要」関連の空フォームが表示される' do
        expect(page).to have_field 'event[title]'
        expect(find_field('event[title]').text).to be_blank
        expect(page).to have_field 'event[plan_image]'
        expect(page).to have_field 'event[body]'
        expect(find_field('event[body]').text).to be_blank
        expect(page).to have_field 'event[fee]'
        expect(find_field('event[fee]').text).to be_blank
        expect(page).to have_field 'event[cancel_change]'
        expect(find_field('event[cancel_change]').text).to be_blank
      end
      it '「スケジュール」関連のフォームが表示される' do
        expect(page).to have_field 'event[start_date]'
        expect(page).to have_field 'event[end_date]'
        expect(page).to have_field 'event[start_time]'
        expect(page).to have_field 'event[end_time]'
      end
      it '「アクセス」関連の空フォームが表示される' do
        expect(page).to have_field 'event[location]'
        expect(find_field('event[location]').text).to be_blank
        expect(page).to have_field 'event[access]'
        expect(find_field('event[access]').text).to be_blank
        expect(page).to have_field 'event[parking]'
      end
      it '「そのほか」の空フォームが表示される' do
        expect(page).to have_field 'event[etc]'
        expect(find_field('event[etc]').text).to be_blank
      end
      it '農業体験の投稿ボタンが表示される' do
        expect(page).to have_button '作成する'
      end
    end

    context '投稿機能の確認：成功時' do
      before do
        fill_in 'event[title]', with: Faker::Lorem.characters(number: 10)
        fill_in 'event[plan_image]', with: Faker::Lorem.characters(number: 30)
        fill_in 'event[body]', with: Faker::Lorem.paragraph
        fill_in 'event[fee]', with: Faker::Number.number(digits: 3)
        fill_in 'event[cancel_change]', with: Faker::Lorem.paragraph
        fill_in 'event[location]', with: Faker::Address.full_address
        fill_in 'event[access]', with: Faker::Lorem.characters(number: 10)
        fill_in 'event[start_date]', with: Date.current + 2
        fill_in 'event[end_date]', with: Date.current + 3
        fill_in 'event[start_time]', with: Faker::Time.between_dates(from: Date.today, to: Date.today + 1, period: :morning)
        fill_in 'event[end_time]', with: Faker::Time.between_dates(from: Date.today + 2, to: Date.today + 3, period: :day)
        fill_in 'event[number_of_participants]', with: Faker::Number.number(digits: 2)
      end

      it '新しい農業体験が正しく保存される' do
        expect { click_button '作成する' }.to change(farmer.events, :count).by(1)
      end
      it '作成した農業体験のページへ遷移する' do
        click_button '作成する'
        expect(current_path).to eq 'farmers/events/' + event.id.to_s
        expect(page).to have_content event.title
      end
      it 'サクセスメッセージが表示される' do
        click_button '作成する'
        expect(page).to have_content '農業体験を作成しました'
      end
    end
  end
end