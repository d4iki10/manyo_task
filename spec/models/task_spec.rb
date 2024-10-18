require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = FactoryBot.create(:user)
        task = Task.new(title: '', content: '企画書を作成する。', user: user)
        expect(task).not_to be_valid
        expect(task.errors[:title]).to include('を入力してください')
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        user = FactoryBot.create(:user)
        task = Task.new(title: 'タスクタイトル', content: '', user: user)
        expect(task).not_to be_valid
        expect(task.errors[:content]).to include('を入力してください')
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        user = FactoryBot.create(:user)
        task = Task.new(title: 'タスクタイトル', content: '企画書を作成する。', user: user)
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能のテスト' do
    before do
      @user = FactoryBot.create(:user)
      @task1 = Task.create!(title: 'タスク1', content: '内容1', status: :not_started, user: @user)
      @task2 = Task.create!(title: 'タスク2', content: '内容2', status: :in_progress, user: @user)
      @task3 = Task.create!(title: 'タスク3', content: '内容3', status: :completed, user: @user)
    end

    context 'タイトルであいまい検索をした場合' do
      it '検索キーワードを含むタスクが絞り込まれる' do
        expect(Task.search_title('タスク1')).to include(@task1)
        expect(Task.search_title('タスク1')).not_to include(@task2, @task3)
      end
    end

    context 'ステータス検索をした場合' do
      it '指定したステータスのタスクが絞り込まれる' do
        expect(Task.search_status('in_progress')).to include(@task2)
        expect(Task.search_status('in_progress')).not_to include(@task1, @task3)
      end
    end

    context 'タイトルとステータスの両方で検索をした場合' do
      it 'タイトルにキーワードを含み、かつ指定したステータスのタスクが絞り込まれる' do
        expect(Task.search_title('タスク').search_status('completed')).to include(@task3)
        expect(Task.search_title('タスク').search_status('completed')).not_to include(@task1, @task2)
      end
    end
  end
end
