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

  describe '農家一覧画面のテスト' do
    before do
      visit farmers_path
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/farmers'
      end
      it 'タイトルが表示される' do
        expect(page).to have_content '農家さん一覧'
      end
      it '農家名・エリアが表示される' do
        expect(page).to have_link "", href: farmer_path(farmer)
        expect(page).to have_content farmer.name
        expect(page).to have_content farmer.farm_address
      end
      it '検索用の都道府県名一覧が表示される' do
        expect(page).to have_content 'エリアから探す'
        expect(page).to have_content '関東'
        expect(page).to have_link '栃木県', href: search_path(prefecture: "栃木県", model: 'farmer')
      end
      it '検索フォーム（文字入力）が表示される' do
        expect(page).to have_field 'content'
      end
    end

    context '検索機能のチェック' do
      it 'エリア検索にて都道府県名をクリックすると、検索結果が表示される' do
        click_link '栃木県'
        expect(current_path).to eq "/search"
        expect(page).to have_content "「栃木県」の検索結果"
        expect(page).to have_link ""
      end
      it 'エリア検索にて都道府県名をクリックし、検索結果が無い場合にメッセージが表示される' do
        click_link '宮城県'
        expect(page).to have_content "該当する農業さんがまだ登録されていません"
      end
      it 'キーワード検索すると、検索結果が表示される' do
        fill_in 'content', with: farmer.name
        find(".btn-warning").click
        expect(current_path).to eq "/search"
        expect(page).to have_content "「#{farmer.name}」の検索結果"
        expect(page).to have_link "", href: farmer_path(farmer)
      end
      it 'キーワード検索し、検索結果が無い場合にメッセージが表示される' do
        fill_in 'content', with: "hogehogehoge"
        find(".btn-warning").click
        expect(page).to have_content "該当する農業さんがまだ登録されていません"
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
      it '農家名・お気に入り件数が表示される' do
        expect(page).to have_link farmer.name, href: farmer_path(farmer)
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
      it '農業体験編集画面へのリンクが存在しない' do
        expect(page).not_to have_link "編集する", href: edit_farmers_event_path(event)
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

  describe '農業体験一覧画面のテスト' do
    before do
      visit events_path
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/events'
      end
      it 'タイトル・タブが表示される' do
        expect(page).to have_content '農業体験一覧'
        expect(page).not_to have_content '終了済みの農業体験'
      end
      it 'イベント名・集合場所（都道府県まで）・開催期間が表示される' do
        expect(page).to have_content event.title
        expect(page).to have_content event.location.match(/^.{2,3}[都道府県]/).to_s
        expect(page).to have_content event.start_date.strftime('%m/%d')
        expect(page).to have_content event.end_date.strftime('%m/%d')
      end
      it '検索用の都道府県名一覧が表示される' do
        expect(page).to have_content 'エリアから探す'
        expect(page).to have_content '関東'
        expect(page).to have_link '栃木県', href: search_path(prefecture: "栃木県", model: 'event')
      end
      it '検索フォーム（文字入力・日付）が表示される' do
        expect(page).to have_field 'content'
        expect(page).to have_field 'event_date'
      end
      it 'ソート用のセレクションフォームが表示される' do
        expect(page).to have_field 'keyword'
      end
      it '農家用の農業体験画面へのリンクが存在しない' do
        expect(page).not_to have_link event.title, href: farmers_event_path(event)
      end
    end

    context '検索機能のチェック' do
      it 'エリア検索にて都道府県名をクリックすると、検索結果が表示される' do
        click_link '栃木県'
        expect(current_path).to eq "/search"
        expect(page).to have_content "「栃木県」の検索結果"
        expect(page).to have_link "", href: event_path(event)
      end
      it 'エリア検索にて都道府県名をクリックし、検索結果が無い場合にメッセージが表示される' do
        click_link '宮城県'
        expect(page).to have_content "予約受付中の農業体験はありません"
      end
      it 'キーワード検索すると、検索結果が表示される' do
        fill_in 'content', with: event.title
        page.all(".btn-warning")[0].click
        expect(current_path).to eq "/search"
        expect(page).to have_content "「#{event.title}」の検索結果"
        expect(page).to have_link "", href: event_path(event)
      end
      it 'キーワード検索し、検索結果が無い場合にメッセージが表示される' do
        fill_in 'content', with: "hogehogehoge"
        page.all(".btn-warning")[0].click
        expect(page).to have_content "予約受付中の農業体験はありません"
      end
      it '日付検索すると、検索結果が表示される' do
        fill_in 'event_date', with: (Date.current + 3).strftime('%Y-%m-%d')
        page.all(".btn-warning")[1].click
        expect(current_path).to eq "/search"
        expect(page).to have_content "「#{(Date.current + 3).strftime('%Y-%m-%d')}」の検索結果"
        expect(page).to have_link "", href: event_path(event)
      end
      it '日付検索し、該当結果が無い場合にメッセージが表示される' do
        fill_in 'event_date', with: (Date.current + 10).strftime('%Y-%m-%d')
        page.all(".btn-warning")[1].click
        expect(page).to have_content "予約受付中の農業体験はありません"
      end
    end
  end

  describe '農業体験のスケジュール画面のテスト' do
    before do
      visit event_schedule_path(event, event.schedules.first)
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s
      end
      it '農家名・お気に入り件数が表示される' do
        expect(page).to have_link farmer.name, href: farmer_path(farmer)
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
      it 'スケジュール編集画面へのリンクが存在しない' do
        expect(page).not_to have_link "編集する", href: edit_farmers_event_schedule_path(event, event.schedules.first)
      end
    end
  end

  describe '農業体験の予約作成画面のテスト' do
    before do
      visit new_event_schedule_reservation_path(event, event.schedules.first)
    end

    context "フォームの表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s + '/reservations/new'
      end
      it 'イベントの内容が表示されている' do
        expect(page).to have_content event.title
        expect(page).to have_content event.fee
        expect(page).to have_content event.location
        expect(page).to have_content event.schedules.first.start_time.strftime('%H:%M')
        expect(page).to have_content event.schedules.first.end_time.strftime('%H:%M')
        expect(page).to have_content "イベント概要をご確認後、予約人数を設定して「次へすすむ」をクリックしてください。"
      end
      it '予約人数の空フォームが表示される' do
        expect(page).to have_field 'reservation[people]'
        expect(find_field('reservation[people]').text).to be_blank
      end
      it '次へすすむボタンが表示される' do
        expect(page).to have_button '次へすすむ'
      end
    end

    context '投稿機能の確認：成功時' do
      before do
        fill_in 'reservation[people]', with: Faker::Number.within(range: 1..5)
      end

      it '次へすすむボタンを押すと、確認画面へ遷移する' do
        click_button '次へすすむ'
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s + '/reservations/confirm'
        expect(page).to have_content "ご予約内容をご確認いただき、問題なければ「予約する」をクリックしてください。"
      end
    end

    context '投稿機能の確認：失敗時（people < 1）' do
      before do
        @people = 0
        fill_in 'reservation[people]', with: @people
      end

      it '新規作成ページから移動しない' do
        click_button '次へすすむ'
        expect(page).to have_content "イベント概要をご確認後、予約人数を設定して「次へすすむ」をクリックしてください。"
      end
      it '新規投稿フォームの内容が正しい' do
        expect(page).to have_field 'reservation[people]', with: @people
      end
      it 'バリデーションエラーが表示される' do
        click_button '次へすすむ'
        expect(page).to have_content "must be greater than or equal to 1"
      end
    end

    context '投稿機能の確認：失敗時（people = 文字）' do
      before do
        @people = "hoge"
        fill_in 'reservation[people]', with: @people
      end

      it '新規作成ページから移動しない' do
        click_button '次へすすむ'
        expect(page).to have_content "イベント概要をご確認後、予約人数を設定して「次へすすむ」をクリックしてください。"
      end
      it '新規投稿フォームの内容が正しい' do
        expect(page).to have_field 'reservation[people]', with: @people
      end
      it 'バリデーションエラーが表示される' do
        click_button '次へすすむ'
        expect(page).to have_content "is not a number"
      end
    end

    context '投稿機能の確認：失敗時（people = float）' do
      before do
        @people = 1.5
        fill_in 'reservation[people]', with: @people
      end

      it '新規作成ページから移動しない' do
        click_button '次へすすむ'
        expect(page).to have_content "イベント概要をご確認後、予約人数を設定して「次へすすむ」をクリックしてください。"
      end
      it '新規投稿フォームの内容が正しい' do
        expect(page).to have_field 'reservation[people]', with: @people
      end
      it 'バリデーションエラーが表示される' do
        click_button '次へすすむ'
        expect(page).to have_content "must be an integer"
      end
    end
  end

  describe '農業体験の予約確認画面のテスト' do
    before do
      visit new_event_schedule_reservation_path(event, event.schedules.first)
      fill_in 'reservation[people]', with: Faker::Number.within(range: 1..5)
      click_button '次へすすむ'
      @reservation = customer.reservations.new(schedule_id: event.schedules.first.id, people: 5)
    end

    context "フォームの表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s + '/reservations/confirm'
      end
      it 'イベントの内容が表示されている' do
        expect(page).to have_content event.title
        expect(page).to have_content event.fee
        expect(page).to have_content event.location
        expect(page).to have_content event.schedules.first.date.strftime('%Y/%m/%d')
        expect(page).to have_content event.schedules.first.start_time.strftime('%H:%M')
        expect(page).to have_content event.schedules.first.end_time.strftime('%H:%M')
        expect(page).to have_content @reservation.people
        expect(page).to have_content event.cancel_change
        expect(page).to have_content event.etc
      end
      it '予約するボタンが表示されており、クリックすると予約完了画面へ遷移する' do
        expect(page).to have_link "予約する", href: event_schedule_reservations_path(event, event.schedules.first)
        click_link "予約する"
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s + '/reservations/thanx'
      end
      it '戻るボタンが表示されており、クリックすると作成画面へ遷移する' do
        expect(page).to have_link "戻る", href: event_schedule_reservations_back_path(event, event.schedules.first)
        click_link "戻る"
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s + '/reservations/back'
      end
    end
  end

  describe '農業体験の予約完了画面のテスト' do
    let!(:reservation) { create(:reservation, customer: customer, schedule: event.schedules.first) }
    before do
      visit event_schedule_reservations_thanx_path(event, event.schedules.first)
    end

    context "フォームの表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s + '/reservations/thanx'
      end
      it '予約詳細ページへのリンクが表示されており、クリックすると予約詳細画面へ遷移する' do
        expect(page).to have_link "予約詳細ページへ", href: event_schedule_reservation_path(event, event.schedules.first, reservation)
        click_link "予約詳細ページへ"
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s + '/reservations/' + reservation.id.to_s
      end
      it 'マイページへ戻るボタンが表示されており、クリックするとマイページへ遷移する' do
        expect(page).to have_link "マイページへ戻る", href: profiles_path
        click_link "マイページへ戻る"
        expect(current_path).to eq '/profiles'
      end
    end
  end

  describe '農業体験の予約詳細画面のテスト' do
    let!(:reservation) { create(:reservation, customer: customer, schedule: event.schedules.first) }
    before do
      visit event_schedule_reservation_path(event, event.schedules.first, reservation)
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s + '/reservations/' + reservation.id.to_s
      end
      it '予約・農業体験の詳細が表示されている' do
        expect(page).to have_content event.title
        expect(page).to have_content event.fee
        expect(page).to have_content event.location
        expect(page).to have_content event.schedules.first.date.strftime('%Y/%m/%d')
        expect(page).to have_content event.schedules.first.start_time.strftime('%H:%M')
        expect(page).to have_content event.schedules.first.end_time.strftime('%H:%M')
        expect(page).to have_content reservation.people
        expect(page).to have_content event.cancel_change
        expect(page).to have_content event.etc
        expect(page).to have_content event.location
        expect(page).to have_content event.access
        expect(page).to have_content event.parking
      end
      it '農業体験詳細画面へのリンクが表示され、クリックすると詳細画面へ遷移する' do
        expect(page).to have_link "農業体験のスケジュール詳細ページへ", href: event_schedule_path(event, event.schedules.first)
        click_link "農業体験のスケジュール詳細ページへ"
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + event.schedules.first.id.to_s
      end
      it '予約をキャンセルするリンクが表示されている' do
        expect(page).to have_link "予約をキャンセルする", href: event_schedule_reservation_path(event_id: event.id, schedule_id: event.schedules.first.id, id: reservation.id)
      end
    end

    context "キャンセル機能の確認" do
      it '予約をキャンセルするリンクをクリックすると予約がキャンセルされる' do
        expect{ click_link "予約をキャンセルする" }.to change(customer.reservations, :count).by(-1)
      end
      it '予約をキャンセルするリンクをクリックすると、農業体験予約一覧へ遷移しサクセスメッセージが表示される' do
        click_link "予約をキャンセルする"
        expect(current_path).to eq '/reservations'
        expect(page).to have_content 'ご予約をキャンセルしました'
      end
    end
  end

  describe '農業体験の予約一覧画面のテスト' do
    let!(:reservation) { create(:reservation, customer: customer, schedule: event.schedules.first) }
    before do
      visit reservations_path
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/reservations'
      end
      it 'タイトルが表示されている' do
        expect(page).to have_content '農業体験の予約一覧'
      end
      it '合計予約数が表示されている' do
        expect(page).to have_content customer.reservations.size
      end
      it 'イベント名、イベント日時、予約人数、料金が表示されている' do
        expect(page).to have_link event.title, href: event_schedule_reservation_path(id: reservation.id, schedule_id: reservation.schedule_id, event_id: reservation.schedule.event_id)
        expect(page).to have_content reservation.schedule.date.strftime('%Y/%m/%d')
        expect(page).to have_content reservation.schedule.start_time.strftime('%H:%M')
        expect(page).to have_content reservation.schedule.end_time.strftime('%H:%M')
        expect(page).to have_content reservation.people
      end
      it 'イベント名をクリックすると、農業体験予約詳細画面へ遷移する' do
        click_link event.title
        expect(current_path).to eq '/events/' + event.id.to_s + '/schedules/' + reservation.schedule.id.to_s + '/reservations/' + reservation.id.to_s
      end
    end
  end

  describe 'レシピ詳細画面のテスト' do
    before do
      visit recipe_path(recipe)
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/recipes/' + recipe.id.to_s
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
      it 'レシピの編集画面・削除のリンクが存在しない' do
        expect(page).not_to have_link '編集する', href: edit_farmers_recipe_path(recipe)
        expect(page).not_to have_link '削除する', href: farmers_recipe_path(recipe)
      end
    end
  end

  describe 'レシピ一覧画面のテスト' do
    before do
      visit recipes_path
    end

    context "表示内容の確認" do
      it 'URLが正しい' do
        expect(current_path).to eq '/recipes'
      end
      it 'タイトルが表示される' do
        expect(page).to have_content 'レシピ一覧'
      end
      it 'レシピ名が表示される' do
        expect(page).to have_content recipe.title
      end
      it '検索フォーム（文字入力）が表示される' do
        expect(page).to have_field 'content'
      end
      it 'ソート用のセレクションフォームが表示される' do
        expect(page).to have_field 'keyword'
      end
      it 'レシピ投稿用のボタンが表示されない' do
        expect(page).not_to have_link "レシピを投稿する", href: new_farmers_recipe_path
      end
    end

    context '検索機能のチェック' do
      it 'キーワード検索すると、検索結果が表示される' do
        fill_in 'content', with: recipe.title
        find(".btn-warning").click
        expect(current_path).to eq "/search"
        expect(page).to have_link recipe.title, href: recipe_path(recipe)
      end
      it 'タイトルに含まれないワード（例：タグ）でキーワード検索すると、検索結果が表示される' do
        fill_in 'content', with: "tag3"
        find(".btn-warning").click
        expect(current_path).to eq "/search"
        expect(page).to have_link recipe.title, href: recipe_path(recipe)
      end
      it 'キーワード検索し、検索結果が無い場合にメッセージが表示される' do
        fill_in 'content', with: "hogehogehoge"
        find(".btn-warning").click
        expect(page).to have_content "レシピがまだ投稿されていません"
      end
    end
  end
end