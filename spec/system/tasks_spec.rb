require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        FactoryBot.create(:task, title: 'task', created_at: '2022-02-19')
        # タスク一覧画面に遷移
        visit tasks_path
        # 登録したタスクが一覧画面に表示されていることを確認
        expect(page).to have_content 'task'
        expect(page).to have_content '2022年02月19日'
      end
    end
  end

  describe '一覧表示機能' do
    # let!を使ってテストデータを事前に作成
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task', created_at: '2022-02-18') }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: '2022-02-17') }
    let!(:third_task) { FactoryBot.create(:task, title: 'third_task', created_at: '2022-02-16') }

    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が表示される' do
        # 一覧画面に遷移
        visit tasks_path

        expect(page).to have_content 'first_task'
        expect(page).to have_content '2022年02月18日'
        expect(page).to have_content 'second_task'
        expect(page).to have_content '2022年02月17日'
        expect(page).to have_content 'third_task'
        expect(page).to have_content '2022年02月16日'
      end
    end
  end

  describe '詳細表示機能' do
    let!(:task) { FactoryBot.create(:task, title: '詳細タスク', content: '詳細内容') }

    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        # 一覧画面に遷移
        visit tasks_path
        # 詳細表示リンクをクリック
        click_link '詳細', href: task_path(task)
        # タスクのタイトルと内容が表示されていることを確認
        expect(page).to have_content '詳細タスク'
        expect(page).to have_content '詳細内容'
      end
    end
  end
end
