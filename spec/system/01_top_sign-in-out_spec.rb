require 'rails_helper'

describe '[step1] farmer / Customer ログイン前のテスト' do
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
        page.all("a")[1].click
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
        recipe_link = recipe_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
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

  describe 'フッターのテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it '農家の皆さまへ：上から1番目のリンクが「vegecircleでできること」である' do
        farmer_about_link = find_all('a')[-3].native.inner_text
        expect(farmer_about_link).to match("vegecircleでできること")
      end
      it '農家の皆さまへ：上から2番目のリンクが「新規登録・ログイン」である' do
        farmer_login = find_all('a')[-1].native.inner_text
        expect(farmer_login).to match("新規登録・ログイン")
      end
      it 'vegecircleについて：左から1番目のリンクが「vegecircleについて」である' do
        about_link = find_all('a')[-2].native.inner_text
        expect(about_link).to match("vegecircleについて")
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it '「vegecircleでできること」を押すと、農家用アバウト画面に遷移する' do
        farmer_about_link = find_all('a')[-3].native.inner_text
        farmer_about_link = farmer_about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link farmer_about_link
        is_expected.to eq '/about_for_farmer'
      end
      it '「新規登録・ログイン」を押すと、農家用新規登録画面に遷移する' do
        farmer_signup = find_all('a')[-1].native.inner_text
        farmer_signup = farmer_signup.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link farmer_signup
        is_expected.to eq '/farmers/sign_up'
      end
      it '「vegecircleについて」を押すと、アバウト画面に遷移する' do
        page.all("a")[-2].click
        is_expected.to eq '/about'
      end
    end
  end
end
