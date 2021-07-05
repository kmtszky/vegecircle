require 'rails_helper'

describe '[step3-1] Farmer ログイン後のテスト' do
  let!(:farmer) { create(:farmer) }
  let!(:other_farmer) { create(:farmer) }
  let!(:event) { create(:event, :with_schedules, farmer: farmer) }
  let!(:other_event) { create(:event, :with_schedules, farmer: other_farmer) }
  let!(:recipe) { create(:recipe, :with_tag_lists, farmer: farmer) }
  let!(:other_recipe) { create(:recipe, :with_tag_lists, farmer: other_farmer) }

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
      it '投稿成功時：新しい投稿と、削除ボタンが表示される' do
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
      it 'フォームに適切な内容が表示される' do
        expect(page).to have_field 'farmer[name]', with: farmer.name
        expect(page).to have_field 'farmer[farm_address]', with: farmer.farm_address
        expect(page).to have_field 'farmer[store_address]', with: farmer.store_address
        expect(page).to have_field 'farmer[introduction]', with: farmer.introduction
      end
      it '画像投稿用のフォームが表示される' do
        expect(page).to have_field 'farmer[farmer_image]'
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

  describe '農業体験・予約一覧（カレンダー）のテスト' do
    before do
      visit farmers_farmers_calender_path
    end

    context 'カレンダー画面の表示内容の確認' do
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
        expect(page).to have_content event.schedules.first.start_time.hour
        expect(page).to have_content event.schedules.first.people
      end
      it '農業体験をクリックすると、農業体験のスケジュール詳細画面へ遷移する' do
        expect(page).to have_link event.title, href: farmers_event_schedule_path(event, event.schedules.first)
        page.all("a")[9].click
        expect(current_path).to eq '/farmers/events/' + event.id.to_s + "/schedules/" + event.schedules.first.id.to_s
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
        image_path = Rails.root.join('app/assets/images/no_images/no_image_md.png')
        attach_file('event[plan_image]', image_path)
        fill_in 'event[body]', with: Faker::Lorem.paragraph
        fill_in 'event[fee]', with: Faker::Number.within(range: 100..1000)
        fill_in 'event[cancel_change]', with: Faker::Lorem.paragraph
        fill_in 'event[location]', with: "栃木県宇都宮市池上町4-2-5"
        fill_in 'event[access]', with: Faker::Lorem.characters(number: 10)
        fill_in 'event[start_date]', with: Faker::Date.between(from: Date.current + 1, to: Date.current + 1)
        fill_in 'event[end_date]', with: Faker::Date.between(from: Date.current + 2, to: Date.current + 3)
        fill_in 'event[start_time]', with: "09:00:00.000"
        fill_in 'event[end_time]', with: "12:00:00.000"
        fill_in 'event[number_of_participants]', with: Faker::Number.within(range: 10..20)
      end

      it '新しい農業体験が正しく保存される' do
        expect { click_button '作成する' }.to change(farmer.events, :count).by(1)
      end
      it '作成した農業体験のページへ遷移する' do
        click_button '作成する'
        expect(current_path).to eq '/farmers/events/' + farmer.events.last.id.to_s
        expect(page).to have_content farmer.events.last.title
      end
      it 'サクセスメッセージが表示される' do
        click_button '作成する'
        expect(page).to have_content('作成しました')
      end
    end

    context '投稿機能の確認：失敗時（body：空, fee：文字, number_of_participants < 1, start_date < end_date < Date.today, start_time > end_time）' do
      before do
        fill_in 'event[title]', with: Faker::Lorem.characters(number: 10)
        image_path = Rails.root.join('app/assets/images/no_images/no_image_md.png')
        attach_file('event[plan_image]', image_path)
        fill_in 'event[body]', with: ''
        fill_in 'event[fee]', with: 'hoge'
        fill_in 'event[cancel_change]', with: Faker::Lorem.paragraph
        @address = Faker::Address.full_address
        fill_in 'event[location]', with: @address
        fill_in 'event[access]', with: Faker::Lorem.characters(number: 10)
        fill_in 'event[start_date]', with: (Date.current - 1)
        fill_in 'event[end_date]', with: (Date.current - 3)
        fill_in 'event[start_time]', with: "12:00:00.000"
        fill_in 'event[end_time]', with: "09:00:00.000"
        fill_in 'event[number_of_participants]', with: 0
      end

      it '新しい農業体験が保存されない' do
        expect { click_button '作成する' }.not_to change(farmer.events, :count)
      end
      it '新規作成ページから移動しない' do
        click_button '作成する'
        expect(current_path).to eq '/farmers/events'
      end
      it '新規投稿フォームの内容が正しい' do
        expect(find_field('event[body]').text).to be_blank
        expect(page).to have_field 'event[location]', with: @address
      end
      it 'バリデーションエラーが表示される' do
        click_button '作成する'
        expect(page).to have_content "can't be blank"
        expect(page).to have_content "is not a number"
        expect(page).to have_content "must be greater than or equal to 1"
        expect(page).to have_content "は本日以降の日付を選択してください"
        expect(page).to have_content "は開始日以降の日付を選択してください"
        expect(page).to have_content "は開始時刻よりも後の時刻を選択してください"
      end
    end
  end

  describe '農業体験画面のテスト' do
    before do
      visit farmers_event_path(event)
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/events/' + event.id.to_s
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
        expect(page).to have_content event.schedules.first.date.strftime('%Y/%m/%d')
        click_link event.schedules.first.date.strftime('%Y/%m/%d')
        expect(current_path).to eq '/farmers/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s
      end
      it '農業体験編集画面へのリンクが存在し、クリックすると農業体験編集画面へ遷移する' do
        expect(page).to have_link "編集する", href: edit_farmers_event_path(event)
        click_link "編集する"
        expect(current_path).to eq '/farmers/events/' + event.id.to_s + '/edit'
      end
      it '「チャット」ボタンを押すと、ページ内のチャットフォームまで移動する' do
        expect(page).to have_link "チャット", href: "#chat"
        click_link "チャット"
        expect(current_path).to eq '/farmers/events/' + event.id.to_s
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
      visit farmers_event_schedule_path(event, event.schedules.first)
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s
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
      it 'スケジュール編集画面へのリンクが存在し、クリックするとスケジュール編集画面へ遷移する' do
        expect(page).to have_link "編集する", href: edit_farmers_event_schedule_path(event, event.schedules.first)
        click_link "編集する"
        expect(current_path).to eq '/farmers/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s + '/edit'
      end
      it '農業体験編集画面へのリンクが存在し、クリックすると農業体験編集画面へ遷移する' do
        expect(page).to have_link "日時以外の項目を編集する", href: edit_farmers_event_path(event)
        click_link "日時以外の項目を編集する"
        expect(current_path).to eq '/farmers/events/' + event.id.to_s + '/edit'
      end
    end
  end

  describe '農業体験一覧画面のテスト' do
    before do
      visit farmers_events_path
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/events'
      end
      it 'タイトル・タブが表示される' do
        expect(page).to have_content '農業体験一覧'
        expect(page).to have_content '予約受付中の農業体験'
        expect(page).to have_content '終了済みの農業体験'
      end
      it 'イベント名・集合場所（都道府県まで）・開催期間が表示される' do
        expect(page).to have_content event.title
        expect(page).to have_content event.location.match(/^.{2,3}[都道府県]/).to_s
        expect(page).to have_content event.start_date.strftime('%m/%d')
        expect(page).to have_content event.end_date.strftime('%m/%d')
      end
      it '他人の投稿が表示されない' do
        expect(page).not_to have_content other_event.title
      end
      it '検索フォーム（文字入力・日付）が表示される' do
        expect(page).to have_field 'content'
        expect(page).to have_field 'event_date'
      end
      it 'ソート用のセレクションフォームが表示される' do
        expect(page).to have_field 'keyword'
      end
      it '農業体験・予約一覧（カレンダー）画面へのリンクが存在し、クリックすると農業体験・予約一覧画面へ遷移する' do
        expect(page).to have_link "カレンダー表示に切り替え", href: farmers_farmers_calender_path
        click_link "カレンダー表示に切り替え"
        expect(current_path).to eq '/farmers/calender'
      end
    end
  end

  describe 'レシピ作成画面のテスト' do
    before do
      visit new_farmers_recipe_path
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/recipes/new'
      end
      it 'タイトル表示される' do
        expect(page).to have_content 'レシピの作成'
      end
      it '入力用の空フォームが表示される' do
        expect(page).to have_field 'recipe[title]'
        expect(find_field('recipe[title]').text).to be_blank
        expect(page).to have_field 'recipe[recipe_image]'
        expect(page).to have_field 'recipe[duration]'
        expect(find_field('recipe[duration]').text).to be_blank
        expect(page).to have_field 'recipe[amount]'
        expect(page).to have_field 'recipe[ingredient]'
        expect(find_field('recipe[ingredient]').text).to be_blank
        expect(page).to have_field 'recipe[recipe]'
        expect(find_field('recipe[recipe]').text).to be_blank
        expect(page).to have_field 'recipe[tag_list]'
        expect(find_field('recipe[tag_list]').text).to be_blank
      end
      it 'レシピの投稿ボタンが表示される' do
        expect(page).to have_button '作成する'
      end
    end

    context '投稿機能の確認：成功時' do
      before do
        fill_in 'recipe[title]', with: Faker::Lorem.characters(number: 10)
        image_path = Rails.root.join('app/assets/images/no_images/no_image_md.png')
        attach_file('recipe[recipe_image]', image_path)
        fill_in 'recipe[duration]', with: Faker::Number.within(range: 10..90)
        select 3, from: 'recipe[amount]'
        fill_in 'recipe[ingredient]', with: Faker::Lorem.paragraph
        fill_in 'recipe[recipe]', with: Faker::Lorem.paragraph
        fill_in 'recipe[tag_list]', with: "タグ1, タグ2, タグ3, タグ4"
      end

      it '新しいレシピが正しく保存される' do
        expect { click_button '作成する' }.to change(farmer.recipes, :count).by(1)
      end
      it '作成したレシピのページへ遷移する' do
        click_button '作成する'
        expect(current_path).to eq '/farmers/recipes/' + farmer.recipes.last.id.to_s
        expect(page).to have_content farmer.recipes.last.title
      end
      it 'サクセスメッセージが表示される' do
        click_button '作成する'
        expect(page).to have_content('レシピを作成しました')
      end
    end

    context '投稿機能の確認：失敗時（duration：float, ingredient・tag_list：空）' do
      before do
        @title = Faker::Lorem.characters(number: 10)
        fill_in 'recipe[title]', with: @title
        image_path = Rails.root.join('app/assets/images/no_images/no_image_md.png')
        attach_file('recipe[recipe_image]', image_path)
        fill_in 'recipe[duration]', with: 1.5
        select 3, from: 'recipe[amount]'
        fill_in 'recipe[ingredient]', with: ''
        fill_in 'recipe[recipe]', with: Faker::Lorem.paragraph
        fill_in 'recipe[tag_list]', with: ''
      end

      it '新しい農業体験が保存されない' do
        expect { click_button '作成する' }.not_to change(farmer.recipes, :count)
      end
      it '新規作成ページから移動しない' do
        click_button '作成する'
        expect(current_path).to eq '/farmers/recipes'
      end
      it '新規投稿フォームの内容が正しい' do
        expect(find_field('recipe[ingredient]').text).to be_blank
        expect(page).to have_field 'recipe[title]', with: @title
      end
      it 'バリデーションのエラーメッセージが表示される' do
        click_button '作成する'
        expect(page).to have_content "can't be blank"
        expect(page).to have_content "must be an integer"
      end
    end
  end

  describe 'レシピ詳細画面のテスト' do
    before do
      visit farmers_recipe_path(recipe)
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/recipes/' + recipe.id.to_s
      end
      it 'お気に入り件数が表示される' do
        expect(page).to have_content recipe.recipe_favorites.size
      end
      it '料理名・調理時間・分量・材料・レシピ・タグが表示される' do
        expect(page).to have_content recipe.title
        expect(page).to have_content recipe.duration
        expect(page).to have_content recipe.amount
        expect(page).to have_content recipe.ingredient
        expect(page).to have_content recipe.recipe
        expect(page).to have_content recipe.tags.first.tag
      end
      it 'レシピの編集画面へのリンクが存在し、クリックすると編集画面へ遷移する' do
        expect(page).to have_link '編集する', href: edit_farmers_recipe_path(recipe)
        click_link "編集する"
        expect(current_path).to eq '/farmers/recipes/' + recipe.id.to_s + '/edit'
      end
      it 'レシピの削除ボタンが表示される' do
        expect(page).to have_link '削除する'
      end
    end

    context "削除機能の確認" do
      it '削除ボタンを押すと、正常に削除される' do
        expect{ click_link "削除する" }.to change(farmer.recipes, :count).by(-1)
      end
      it '削除するとマイページに遷移し、サクセスメッセージが表示される' do
        click_link "削除する"
        expect(page).to have_content "レシピを削除しました"
        expect(current_path).to eq "/farmers/farmers"
      end
    end
  end

  describe 'レシピ編集画面のテスト' do
    before do
      visit edit_farmers_recipe_path(recipe)
    end

    context "表示内容の確認" do
      it 'フォームに適切な内容が表示される' do
        expect(page).to have_field 'recipe[title]', with: recipe.title
        expect(page).to have_field 'recipe[duration]', with: recipe.duration
        expect(page).to have_select 'recipe[amount]', selected: recipe.amount.to_s
        expect(page).to have_field 'recipe[ingredient]', with: recipe.ingredient
        expect(page).to have_field 'recipe[recipe]', with: recipe.recipe
        expect(page).to have_field 'recipe[tag_list]'
      end
      it '画像投稿用のフォームが表示される' do
        expect(page).to have_field 'recipe[recipe_image]'
      end
      it '「更新する」ボタンが表示される' do
        expect(page).to have_button '更新する'
      end
    end

    context '更新成功時' do
      before do
        @recipe_old_title = recipe.title
        @recipe_tags = recipe.tags
        fill_in 'recipe[title]', with: Faker::Lorem.characters(number: 10)
        fill_in 'recipe[duration]', with: Faker::Number.within(range: 10..90)
        select 3, from: 'recipe[amount]'
        fill_in 'recipe[ingredient]', with: Faker::Lorem.paragraph
        fill_in 'recipe[recipe]', with: Faker::Lorem.paragraph
        fill_in 'recipe[tag_list]', with: "タグ1, タグ2, タグ3"
        click_button '更新する'
      end

      it '変更内容が正しく更新される' do
        expect(recipe.reload.title).not_to eq @recipe_old_title
        expect(recipe.reload.tags).not_to eq @recipe_tags
      end
      it 'リダイレクト先がレシピの詳細画面である' do
        expect(current_path).to eq '/farmers/recipes/' + recipe.id.to_s
      end
      it 'サクセスメッセージが表示される' do
        expect(page).to have_content 'レシピを更新しました'
      end
    end

    context '更新失敗時' do
      before do
        fill_in 'recipe[title]', with: Faker::Lorem.characters(number: 10)
        fill_in 'recipe[duration]', with: 1.5
        select 3, from: 'recipe[amount]'
        fill_in 'recipe[ingredient]', with: ''
        fill_in 'recipe[recipe]', with: Faker::Lorem.paragraph
        fill_in 'recipe[tag_list]', with: ''
        click_button '更新する'
      end

      it '編集画面から遷移しない' do
        expect(current_path).to eq '/farmers/recipes/' + recipe.id.to_s
      end
      it 'バリデーションのエラーメッセージが表示される' do
        expect(page).to have_content "can't be blank"
        expect(page).to have_content "must be an integer"
      end
    end
  end

  describe 'レシピ一覧画面のテスト' do
    before do
      visit farmers_recipes_path
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers/recipes'
      end
      it 'タイトルが表示される' do
        expect(page).to have_content 'レシピ一覧'
      end
      it 'レシピ名が表示される' do
        expect(page).to have_content recipe.title
      end
      it '他人の投稿が表示されない' do
        expect(page).not_to have_content other_recipe.title
      end
      it '検索フォーム（文字入力・日付）が表示される' do
        expect(page).to have_field 'content'
      end
      it 'ソート用のセレクションフォームが表示される' do
        expect(page).to have_field 'keyword'
      end
      it 'レシピ投稿用のボタンが表示され、クリックするとレシピ作成画面へ遷移する' do
        expect(page).to have_link "レシピを投稿する", href: new_farmers_recipe_path
        click_link "レシピを投稿する"
        expect(current_path).to eq '/farmers/recipes/new'
      end
    end
  end
end