require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  # テストデータを事前に作成（let!を使用して即時評価）
  let!(:first_task) { FactoryBot.create(:task, title: '最初のタスク', content: '最初の内容', created_at: Time.current - 3.days) }
  let!(:second_task) { FactoryBot.create(:task, title: '次のタスク', content: '次の内容', created_at: Time.current - 2.days) }
  let!(:third_task) { FactoryBot.create(:task, title: '最新のタスク', content: '最新の内容', created_at: Time.current - 1.day) }

  # 共通の前処理（beforeブロック）
  before do
    visit tasks_path
  end

  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        # タスク一覧画面から新規タスク登録画面へ移動
        click_link 'タスクを登録する'

        # 新規タスク登録フォームに入力
        fill_in 'タイトル', with: '新規タスク'
        fill_in '内容', with: '新規タスクの内容'

        # タスクを登録するボタンをクリック
        click_button '登録する'

        # タスク一覧画面に遷移して、新規タスクが表示されていることを確認
        expect(page).to have_content '新規タスク'
        expect(page).to have_content '新規タスクの内容'
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が作成日時の降順で表示される' do
        # タスクが作成日時の降順で表示されていることを確認
        task_list = all('tbody tr')

        expect(task_list[0]).to have_content '最新のタスク'
        expect(task_list[1]).to have_content '次のタスク'
        expect(task_list[2]).to have_content '最初のタスク'
      end
    end

    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        # タスク一覧画面から新規タスク登録画面へ移動
        click_link 'タスクを登録する'

        # 新規タスク登録フォームに入力
        fill_in 'タイトル', with: '新しく追加されたタスク'
        fill_in '内容', with: '新しく追加されたタスクの内容'

        # タスクを登録するボタンをクリック
        click_button '登録する'

        # タスク一覧画面に遷移して、新しいタスクが一番上に表示されていることを確認
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content '新しく追加されたタスク'
        expect(task_list[0]).to have_content '新しく追加されたタスクの内容'
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        # 任意のタスク（例えば、second_task）の詳細ページに遷移
        visit task_path(second_task)

        # タスクのタイトルと内容が表示されていることを確認
        expect(page).to have_content '次のタスク'
        expect(page).to have_content '次の内容'
      end
    end
  end
end
