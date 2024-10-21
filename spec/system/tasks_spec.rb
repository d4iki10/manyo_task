require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  before do
    # FactoryBotを使わずに手動でユーザを作成
    @user = User.create!(name: 'テストユーザ', email: 'test@example.com', password: 'password', password_confirmation: 'password')

    # ユーザがログインする
    visit new_session_path
    fill_in 'メールアドレス', with: @user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'

    # タスクを作成
    @task = @user.tasks.create!(title: 'テストタスク', content: 'テストタスクの内容')
  end

  describe 'タスク一覧表示機能' do
    it '自分のタスクが表示される' do
      visit tasks_path
      expect(page).to have_content 'テストタスク'
      expect(page).not_to have_content '他のタスク'
    end
  end

  describe 'タスク詳細表示機能' do
    context '自分のタスク詳細画面にアクセスした場合' do
      it 'タスクの詳細が表示される' do
        visit task_path(@user_task)
        expect(page).to have_content 'テストタスク'
        expect(page).to have_content 'テスト内容'
      end
    end

    context '他人のタスク詳細画面にアクセスした場合' do
      it 'タスク一覧画面に遷移し、フラッシュメッセージが表示される' do
        visit task_path(@other_task)
        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content 'アクセス権限がありません'
      end
    end
  end

  describe 'タスク編集機能' do
    context '自分のタスクを編集した場合' do
      it '編集した内容が表示される' do
        visit edit_task_path(@user_task)
        fill_in 'タスクのタイトル', with: '編集後のタスク'
        click_button '更新する'
        expect(page).to have_content '編集後のタスク'
        expect(page).to have_content 'タスクを更新しました'
      end
    end

    context '他人のタスク編集画面にアクセスした場合' do
      it 'タスク一覧画面に遷移し、フラッシュメッセージが表示される' do
        visit edit_task_path(@other_task)
        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content 'アクセス権限がありません'
      end
    end
  end

  describe 'タスク削除機能' do
    context '自分のタスクを削除した場合' do
      it 'タスクが削除される' do
        visit tasks_path
        accept_confirm do
          click_link '削除', href: task_path(@user_task)
        end
        expect(page).to have_content 'タスクを削除しました'
        expect(page).not_to have_content 'テストタスク'
      end
    end
  end

  describe '検索機能' do
    before do
      @user.tasks.create!(title: 'Rubyの勉強', content: 'Rubyを使ってRailsアプリを作成する。', status: :not_started)
      @user.tasks.create!(title: 'JavaScriptの勉強', content: 'フロントエンドのスキルを向上させる。', status: :in_progress)
      @user.tasks.create!(title: 'Ruby on Railsの勉強', content: 'Railsの機能を深く理解する。', status: :completed)
    end

    context 'タイトルであいまい検索をした場合' do
      it '検索キーワードを含むタスクが絞り込まれる' do
        visit tasks_path
        fill_in 'タイトル', with: 'Ruby'
        click_button '検索'
        expect(page).to have_content 'Rubyの勉強'
        expect(page).to have_content 'Ruby on Railsの勉強'
        expect(page).not_to have_content 'JavaScriptの勉強'
      end
    end

    context 'ステータス検索をした場合' do
      it '指定したステータスのタスクが絞り込まれる' do
        visit tasks_path
        select '完了', from: 'ステータス'
        click_button '検索'
        expect(page).to have_content 'Ruby on Railsの勉強'
        expect(page).not_to have_content 'Rubyの勉強'
        expect(page).not_to have_content 'JavaScriptの勉強'
      end
    end

    context 'タイトルとステータスの両方で検索をした場合' do
      it 'タイトルにキーワードを含み、かつ指定したステータスのタスクが絞り込まれる' do
        visit tasks_path
        fill_in 'タイトル', with: 'Ruby'
        select '完了', from: 'ステータス'
        click_button '検索'
        expect(page).to have_content 'Ruby on Railsの勉強'
        expect(page).not_to have_content 'Rubyの勉強'
        expect(page).not_to have_content 'JavaScriptの勉強'
      end
    end
  end
end
