require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  describe '登録機能' do
    context 'ユーザを登録した場合' do
      it 'タスク一覧画面に遷移し、フラッシュメッセージが表示される' do
        visit new_user_path
        fill_in '名前', with: 'Test User'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        click_button '登録する'
        expect(page).to have_content 'タスク一覧ページ'
        expect(page).to have_selector '.alert-notice', text: 'アカウントを登録しました'
      end
    end

    context 'すべてのフォームが未入力の場合' do
      it 'バリデーションエラーメッセージが表示される' do
        visit new_user_path
        click_button '登録する'
        expect(page).to have_content '名前を入力してください'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content 'パスワードを入力してください'
      end
    end

    context 'パスワードが6文字未満の場合' do
      it 'バリデーションエラーメッセージが表示される' do
        visit new_user_path
        fill_in '名前', with: 'Test User'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'pass'
        fill_in 'パスワード（確認）', with: 'pass'
        click_button '登録する'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
      end
    end

    context 'パスワードとパスワード（確認）が一致しない場合' do
      it 'バリデーションエラーメッセージが表示される' do
        visit new_user_path
        fill_in '名前', with: 'Test User'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password1'
        fill_in 'パスワード（確認）', with: 'password2'
        click_button '登録する'
        expect(page).to have_content 'パスワード（確認）とパスワードの入力が一致しません'
      end
    end

    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、フラッシュメッセージが表示される' do
        visit tasks_path
        expect(page).to have_content 'ログインページ'
        expect(page).to have_selector '.alert-danger', text: 'ログインしてください'
      end
    end
  end

  describe 'ログイン機能' do
    before do
      @user = FactoryBot.create(:user)
    end

    context '登録済みのユーザでログインした場合' do
      it 'タスク一覧画面に遷移し、フラッシュメッセージが表示される' do
        visit new_sessions_path
        fill_in 'メールアドレス', with: @user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'タスク一覧ページ'
        expect(page).to have_selector '.alert-notice', text: 'ログインしました'
      end
    end

    context 'ログアウトした場合' do
      it 'ログイン画面に遷移し、フラッシュメッセージが表示される' do
        visit new_sessions_path
        fill_in 'メールアドレス', with: @user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        click_link 'ログアウト'
        expect(page).to have_content 'ログインページ'
        expect(page).to have_selector '.alert-notice', text: 'ログアウトしました'
      end
    end

    context 'ログイン中にログイン画面にアクセスした場合' do
      it 'タスク一覧画面に遷移し、フラッシュメッセージが表示される' do
        visit new_sessions_path
        fill_in 'メールアドレス', with: @user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        visit new_sessions_path
        expect(page).to have_content 'タスク一覧ページ'
        expect(page).to have_selector '.alert-danger', text: 'ログアウトしてください'
      end
    end

    context 'ログイン中にアカウント登録画面にアクセスした場合' do
      it 'タスク一覧画面に遷移し、フラッシュメッセージが表示される' do
        visit new_sessions_path
        fill_in 'メールアドレス', with: @user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        visit new_user_path
        expect(page).to have_content 'タスク一覧ページ'
        expect(page).to have_selector '.alert-danger', text: 'ログアウトしてください'
      end
    end
  end

  describe 'アカウント編集機能' do
    before do
      @user = FactoryBot.create(:user)
      visit new_sessions_path
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
    end

    context 'アカウントを編集した場合' do
      it 'アカウント詳細ページに遷移し、フラッシュメッセージが表示される' do
        visit edit_user_path(@user)
        fill_in '名前', with: 'Updated User'
        click_button '更新する'
        expect(page).to have_content 'アカウント詳細ページ'
        expect(page).to have_content 'Updated User'
        expect(page).to have_selector '.alert-notice', text: 'アカウントを更新しました'
      end
    end

    context '編集に失敗した場合、エラーメッセージが表示される' do
      it 'アカウント編集ページに戻り、エラーメッセージが表示される' do
        visit edit_user_path(@user)
        fill_in 'メールアドレス', with: ''
        click_button '更新する'
        expect(page).to have_content 'アカウント編集ページ'
        expect(page).to have_content 'メールアドレスを入力してください'
      end
    end

    context '他人のアカウント編集画面にアクセスした場合' do
      it 'タスク一覧画面に遷移し、フラッシュメッセージが表示される' do
        other_user = FactoryBot.create(:user, email: 'other@example.com')
        visit edit_user_path(other_user)
        expect(page).to have_content 'タスク一覧ページ'
        expect(page).to have_selector '.alert-danger', text: 'アクセス権限がありません'
      end
    end
  end
end
