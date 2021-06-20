require 'rails_helper'

describe '[step2] Farmer / Customer ログイン・ログアウトのテスト' do
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
        expect(current_path).to eq '/farmers/farmers'
      end
      it '新規登録後にサクセスメッセージが表示される' do
        click_button '新規登録'
        expect(page).to have_content 'アカウントの登録が完了しました'
      end
    end

    context '新規登録失敗のテスト' do
      before do
        fill_in 'farmer[name]', with: ''
        fill_in 'farmer[store_address]', with: ''
        fill_in 'farmer[farm_address]', with: ''
        fill_in 'farmer[email]', with: Faker::Internet.email
        fill_in 'farmer[password]', with: 'password'
        fill_in 'farmer[password_confirmation]', with: 'password'
        click_button '新規登録'
      end

      it '新規登録に失敗し、新規登録画面にリダイレクトされる' do
        expect(current_path).to eq '/farmers'
      end
      it 'エラーメッセージが表示される：空白' do
        expect(page).to have_content "can't be blank"
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
        expect(current_path).to eq '/farmers/farmers'
      end
      it 'ログイン後にサクセスメッセージが表示される' do
        expect(page).to have_content 'ログインしました'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/farmers/sign_in'
      end
      it 'エラーメッセージが表示される' do
        expect(page).to have_content 'が有効ではありません'
      end
    end
  end

  describe 'ヘッダーのテスト: farmerがログインしている場合' do
    let(:farmer) { create(:farmer) }

    before do
      visit new_farmer_session_path
      fill_in 'farmer[email]', with: farmer.email
      fill_in 'farmer[password]', with: farmer.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示を確認' do
      it 'タイトルが表示される' do
        expect(page).to have_content 'マイページ'
      end
      it 'nav：左から1番目のリンクが「マイページ」である' do
        mypage_link = find_all('a')[1].native.inner_text
        expect(mypage_link).to match(" マイページ")
      end
      it 'nav：左から2番目のリンクが「通知」である' do
        notice_link = find_all('a')[2].native.inner_text
        expect(notice_link).to match(" 通知")
      end
      it 'nav：左から3番目のリンクが「農業体験・予約一覧」である' do
        event_link = find_all('a')[3].native.inner_text
        expect(event_link).to match(" 農業体験・予約一覧")
      end

      it 'nav：左から4番目のリンクが「レシピ」である' do
        recipe_link = find_all('a')[4].native.inner_text
        expect(recipe_link).to match(" レシピ")
      end
      it 'nav：左から5番目のリンクが「ログアウト」である' do
        farmer_log_out_link = find_all('a')[5].native.inner_text
        expect(farmer_log_out_link).to match(" ログアウト")
      end
    end

    context 'ヘッダーのリンクの内容を確認' do
      subject { current_path }

      it '「マイページ」を押すと、マイページへ遷移する' do
        mypage_link = find_all('a')[1].native.inner_text
        mypage_link = mypage_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link mypage_link
        is_expected.to eq '/farmers/farmers'
      end
      it '「農業体験・予約一覧」を押すと、農業体験・予約一覧へ遷移する' do
        event_link = find_all('a')[3].native.inner_text
        event_link = event_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link event_link
        is_expected.to eq '/farmers/calender'
      end
      it '「レシピ」を押すと、レシピへ遷移する' do
        recipe_link = find_all('a')[4].native.inner_text
        recipe_link = recipe_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link recipe_link
        is_expected.to eq '/farmers/recipes'
      end
    end
  end

  describe 'farmer:ログアウトのテスト' do
    let(:farmer) { create(:farmer) }

    before do
      visit new_farmer_session_path
      fill_in 'farmer[email]', with: farmer.email
      fill_in 'farmer[password]', with: farmer.password
      click_button 'ログイン'
      farmer_log_out_link = find_all('a')[5].native.inner_text
      farmer_log_out_link = farmer_log_out_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link farmer_log_out_link
    end

    context 'farmerログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
        expect(page).to have_link '', href: '/about'
      end
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
      it 'ログアウト後にサクセスメッセージが表示される' do
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end

  describe 'customer：新規登録のテスト' do
    before do
      visit new_customer_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/customers/sign_up'
      end
      it '「新規登録」と表示される' do
        expect(page).to have_content '新規登録'
      end
      it 'nicknameフォームが表示される' do
        expect(page).to have_field 'customer[nickname]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'customer[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'customer[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'customer[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'customer[nickname]', with: Faker::Lorem.characters(number: 10)
        fill_in 'customer[email]', with: Faker::Internet.email
        fill_in 'customer[password]', with: 'password'
        fill_in 'customer[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(Customer.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/profiles'
      end
      it '新規登録後にサクセスメッセージが表示される' do
        click_button '新規登録'
        expect(page).to have_content 'アカウントの登録が完了しました'
      end
    end

    context '新規登録失敗のテスト' do
      before do
        fill_in 'customer[nickname]', with: ''
        fill_in 'customer[email]', with: Faker::Internet.email
        fill_in 'customer[password]', with: 'password'
        fill_in 'customer[password_confirmation]', with: 'password'
        click_button '新規登録'
      end

      it '新規登録に失敗し、新規登録画面にリダイレクトされる' do
        expect(current_path).to eq '/customers'
      end
      it 'エラーメッセージが表示される：空白' do
        expect(page).to have_content "can't be blank"
      end
    end
  end

  describe 'customer：ログイン機能のテスト' do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/customers/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'customer[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'customer[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'customer[email]', with: customer.email
        fill_in 'customer[password]', with: customer.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/profiles'
      end
      it 'ログイン後にサクセスメッセージが表示される' do
      expect(page).to have_content 'ログインしました'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'customer[email]', with: ''
        fill_in 'customer[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/customers/sign_in'
      end
      it 'エラーメッセージが表示される' do
        expect(page).to have_content 'が有効ではありません'
      end
    end
  end

  describe 'ヘッダーのテスト: customerがログインしている場合' do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示を確認' do
      it 'タイトルが表示される' do
        expect(page).to have_content 'マイページ'
      end
      it 'nav：左から1番目のリンクが「マイページ」である' do
        mypage_link = find_all('a')[1].native.inner_text
        expect(mypage_link).to match(" マイページ")
      end
      it 'nav：左から2番目のリンクが「予約一覧」である' do
        reservation_link = find_all('a')[2].native.inner_text
        expect(reservation_link).to match(" 予約一覧")
      end
      it 'nav：左から3番目のリンクが「通知」である' do
        notice_link = find_all('a')[3].native.inner_text
        expect(notice_link).to match(" 通知")
      end
      it 'nav：左から4番目のリンクが「近くの農家さん」である' do
        farmer_link = find_all('a')[4].native.inner_text
        expect(farmer_link).to match(" 近くの農家さん")
      end
      it 'nav：左から5番目のリンクが「農業体験」である' do
        event_link = find_all('a')[5].native.inner_text
        expect(event_link).to match(" 農業体験")
      end
      it 'nav：左から6番目のリンクが「レシピ」である' do
        recipe_link = find_all('a')[6].native.inner_text
        expect(recipe_link).to match(" レシピ")
      end
      it 'nav：左から7番目のリンクが「ログアウト」である' do
        customer_log_out_link = find_all('a')[7].native.inner_text
        expect(customer_log_out_link).to match(" ログアウト")
      end
    end

    context 'ヘッダーのリンクの内容を確認' do
      subject { current_path }

      it '「マイページ」を押すと、マイページへ遷移する' do
        mypage_link = find_all('a')[1].native.inner_text
        mypage_link = mypage_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link mypage_link
        is_expected.to eq '/profiles'
      end
      it '「予約一覧」を押すと、予約一覧へ遷移する' do
        reservation_link = find_all('a')[2].native.inner_text
        reservation_link = reservation_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link reservation_link
        is_expected.to eq '/reservations'
      end
      it '「近くの農家さん」を押すと、農家一覧へ遷移する' do
        farmer_link = find_all('a')[4].native.inner_text
        farmer_link = farmer_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link farmer_link
        is_expected.to eq '/farmers'
      end
      it '「農業体験」を押すと、農業体験一覧へ遷移する' do
        event_link = find_all('a')[5].native.inner_text
        event_link = event_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link event_link
        is_expected.to eq '/events'
      end
      it '「レシピ」を押すと、レシピへ遷移する' do
        recipe_link = find_all('a')[6].native.inner_text
        recipe_link = recipe_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link recipe_link
        is_expected.to eq '/recipes'
      end
    end
  end

  describe 'customer：ログアウトのテスト' do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
      customer_log_out_link = find_all('a')[7].native.inner_text
      customer_log_out_link = customer_log_out_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link customer_log_out_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
        expect(page).to have_link '', href: '/about'
      end
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
      it 'ログアウト後のサクセスメッセージが表示されている' do
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end
end