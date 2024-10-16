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

  # 新たに追加するテストケース

  describe '検索機能' do
    before do
      @task1 = FactoryBot.create(:task, title: 'Rubyの勉強', content: 'Rubyを使ってRailsアプリを作成する。', status: :not_started)
      @task2 = FactoryBot.create(:task, title: 'JavaScriptの勉強', content: 'フロントエンドのスキルを向上させる。', status: :in_progress)
      @task3 = FactoryBot.create(:task, title: 'Ruby on Railsの勉強', content: 'Railsの機能を深く理解する。', status: :completed)
    end

    context 'タイトルであいまい検索をした場合' do
      it '検索キーワードを含むタスクが絞り込まれる' do
        # 一覧画面に遷移
        visit tasks_path
        # 検索フォームにキーワードを入力
        fill_in 'search_title', with: 'Ruby'
        # 検索ボタンをクリック
        click_button '検索'
        # 検索結果が正しく表示されていることを確認
        expect(page).to have_content 'Rubyの勉強'
        expect(page).to have_content 'Ruby on Railsの勉強'
        expect(page).not_to have_content 'JavaScriptの勉強'
      end
    end

    context 'ステータス検索をした場合' do
      it '指定したステータスのタスクが絞り込まれる' do
        # 一覧画面に遷移
        visit tasks_path
        # ステータスを選択
        select '完了', from: 'search_status'
        # 検索ボタンをクリック
        click_button '検索'
        # 検索結果が正しく表示されていることを確認
        expect(page).to have_content 'Ruby on Railsの勉強'
        expect(page).not_to have_content 'Rubyの勉強'
        expect(page).not_to have_content 'JavaScriptの勉強'
      end
    end

    context 'タイトルとステータスの両方で検索をした場合' do
      it 'タイトルにキーワードを含み、かつ指定したステータスのタスクが絞り込まれる' do
        # 一覧画面に遷移
        visit tasks_path
        # タイトルにキーワードを入力
        fill_in 'search_title', with: 'Ruby'
        # ステータスを選択
        select '完了', from: 'search_status'
        # 検索ボタンをクリック
        click_button '検索'
        # 検索結果が正しく表示されていることを確認
        expect(page).to have_content 'Ruby on Railsの勉強'
        expect(page).not_to have_content 'Rubyの勉強'
        expect(page).not_to have_content 'JavaScriptの勉強'
      end
    end
  end

  describe 'ソート機能' do
    before do
      @task1 = FactoryBot.create(:task, title: 'タスクA', priority: :low, deadline_on: '2024-12-31')
      @task2 = FactoryBot.create(:task, title: 'タスクB', priority: :high, deadline_on: '2024-11-30')
      @task3 = FactoryBot.create(:task, title: 'タスクC', priority: :medium, deadline_on: '2024-10-31')
    end

    context '終了期限でソートした場合' do
      it '終了期限の近い順にタスクが並ぶ' do
        # 一覧画面に遷移
        visit tasks_path
        # 終了期限のソートリンクをクリック
        click_link '終了期限'
        # タスクの表示順序を確認
        task_rows = all('tbody tr')
        expect(task_rows[0]).to have_content 'タスクC'
        expect(task_rows[1]).to have_content 'タスクB'
        expect(task_rows[2]).to have_content 'タスクA'
      end
    end
  end

  describe 'ページネーション機能' do
    before do
      # 15件のタスクを作成
      15.times do |i|
        FactoryBot.create(:task, title: "タスク#{i + 1}", created_at: "2024-10-#{i + 1}")
      end
    end

    context 'タスクが11件以上存在する場合' do
      it 'ページネーションが表示され、2ページ目にタスクが表示される' do
        # 一覧画面に遷移
        visit tasks_path
        # 1ページ目のタスクが表示されていることを確認
        expect(page).to have_content 'タスク15'
        expect(page).to have_content 'タスク6'
        expect(page).not_to have_content 'タスク5'

        # 2ページ目に移動
        click_link '2'

        # 2ページ目のタスクが表示されていることを確認
        expect(page).to have_content 'タスク5'
        expect(page).to have_content 'タスク1'
        expect(page).not_to have_content 'タスク6'
      end
    end
  end

  describe '編集機能' do
    let!(:task) { FactoryBot.create(:task, content: '編集前内容') }

    context 'タスクを編集した場合' do
      it '編集後の内容が表示される' do
        # 一覧画面に遷移
        visit tasks_path
        # 編集リンクをクリック
        click_link '編集', href: edit_task_path(task)
        # フォームに新しい値を入力
        fill_in '内容', with: '編集後内容'
        # フォームを送信
        click_button '更新する'
        # 編集後の内容が表示されていることを確認
        expect(page).to have_content '編集後内容'
        expect(page).not_to have_content '編集前内容'
      end
    end
  end

  describe '削除機能' do
    let!(:task) { FactoryBot.create(:task, content: '削除する内容') }

    context 'タスクを削除した場合' do
      it 'タスクが削除されて一覧から消える' do
        # 一覧画面に遷移
        visit tasks_path
        # 削除リンクをクリック
        accept_confirm do
          click_link '削除', href: task_path(task)
        end
        # タスクが削除されたことを確認
        expect(page).not_to have_content '削除する内容'
      end
    end
  end
end
