require 'rails_helper'

describe '[STEP1] farmer / Customer ログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'タイトルが表示される' do
        expect(page).to have_content "べ ジ サ ー ク ル"
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before do
      visit '/about'
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/about'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'トップ画面へのリンク（ロゴマーク）が表示される' do
        home_link = find_all('a')[0].native.inner_text
        expect(page).to have_link home_link, href: root_path
      end
      it 'nav：左から1番目のリンクが「vegecircleについて」である' do
        about_link = find_all('a')[1].native.inner_text
        expect(about_link).to match(" vegecircleについて")
      end
      it 'nav：左から2番目のリンクが「近くの農家さん」である' do
        farmer_link = find_all('a')[2].native.inner_text
        expect(farmer_link).to match(" 近くの農家さん")
      end
      it 'nav：左から3番目のリンクが「農業体験」である' do
        event_link = find_all('a')[3].native.inner_text
        expect(event_link).to match(" 農業体験")
      end
      it 'nav：左から4番目のリンクが「レシピ」である' do
        recipe_link = find_all('a')[4].native.inner_text
        expect(recipe_link).to match(" レシピ")
      end
      it 'nav：左から5番目のリンクが「ログイン」である' do
        customer_log_in_link = find_all('a')[5].native.inner_text
        expect(customer_log_in_link).to match(" ログイン")
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'ロゴマークを押すと、トップ画面に遷移する' do
        home_link = find_all('a')[0].native.inner_text
        home_link = home_link.delete(' ')
        home_link.gsub!(/\n/, '')
        click_link home_link
        is_expected.to eq '/'
      end
      it '「vegecircleについて」を押すと、アバウト画面に遷移する' do
        about_link = find_all('a')[1].native.inner_text
        about_link = about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link about_link
        is_expected.to eq '/about'
      end
      it '「近くの農家さん」を押すと、農家一覧画面に遷移する' do
        farmer_link = find_all('a')[2].native.inner_text
        farmer_link = farmer_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link farmer_link
        is_expected.to eq '/farmers'
      end
      it '「農業体験」を押すと、農業体験一覧画面に遷移する' do
        event_link = find_all('a')[3].native.inner_text
        event_link = event_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link event_link
        is_expected.to eq '/events'
      end
      it '「レシピ」を押すと、農家一覧画面に遷移する' do
        recipe_link = find_all('a')[4].native.inner_text
        recipe_link = farmer_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link recipe_link
        is_expected.to eq '/recipes'
      end
      it '「ログイン」を押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[5].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link
        is_expected.to eq '/customers/sign_in'
      end
    end
  end

  describe 'customer新規登録のテスト' do
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
        expect { click_button '新規登録' }.to change(customer.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/profiles'
      end
    end
  end

  describe 'customerログイン' do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/customers/sign_in'
      end
      it '「Log in」と表示される' do
        expect(page).to have_content 'Log in'
      end
      it 'nicknameフォームが表示される' do
        expect(page).to have_field 'customer[nickname]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'customer[password]'
      end
      it 'Sign upボタンが表示される' do
        expect(page).to have_button 'Log in'
      end
      it 'emailフォームは表示されない' do
        expect(page).not_to have_field 'customer[email]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'customer[nickname]', with: customer.nickname
        fill_in 'customer[password]', with: customer.password
        click_button 'Log in'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/customers/' + customer.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'customer[nickname]', with: ''
        fill_in 'customer[password]', with: ''
        click_button 'Log in'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/customers/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
      fill_in 'customer[nickname]', with: customer.nickname
      fill_in 'customer[password]', with: customer.password
      click_button 'Log in'
    end

    context 'ヘッダーの表示を確認' do
      it 'タイトルが表示される' do
        expect(page).to have_content 'Bookers'
      end
      it 'Homeリンクが表示される: 左上から1番目のリンクが「Home」である' do
        home_link = find_all('a')[1].native.inner_text
        expect(home_link).to match(/home/i)
      end
      it 'customersリンクが表示される: 左上から2番目のリンクが「customers」である' do
        customers_link = find_all('a')[2].native.inner_text
        expect(customers_link).to match(/customers/i)
      end
      it 'Booksリンクが表示される: 左上から3番目のリンクが「Books」である' do
        books_link = find_all('a')[3].native.inner_text
        expect(books_link).to match(/books/i)
      end
      it 'log outリンクが表示される: 左上から4番目のリンクが「logout」である' do
        logout_link = find_all('a')[4].native.inner_text
        expect(logout_link).to match(/logout/i)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
      fill_in 'customer[nickname]', with: customer.nickname
      fill_in 'customer[password]', with: customer.password
      click_button 'Log in'
      logout_link = find_all('a')[4].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
        expect(page).to have_link '', href: '/home/about'
      end
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end
