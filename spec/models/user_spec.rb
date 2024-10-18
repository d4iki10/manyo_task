require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: '', email: 'test@example.com', password: 'password', password_confirmation: 'password')
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include('を入力してください')
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'Test User', email: '', password: 'password', password_confirmation: 'password')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('を入力してください')
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'Test User', email: 'test@example.com', password: '', password_confirmation: '')
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('を入力してください')
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        User.create!(name: 'Existing User', email: 'test@example.com', password: 'password', password_confirmation: 'password')
        user = User.new(name: 'New User', email: 'test@example.com', password: 'password', password_confirmation: 'password')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('メールアドレスはすでに使用されています')
      end
    end

    context 'ユーザのメールアドレスの大文字小文字を区別しない場合' do
      it 'バリデーションに失敗する' do
        User.create!(name: 'Existing User', email: 'test@example.com', password: 'password', password_confirmation: 'password')
        user = User.new(name: 'New User', email: 'TEST@example.com', password: 'password', password_confirmation: 'password')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('メールアドレスはすでに使用されています')
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'Test User', email: 'test@example.com', password: 'pass', password_confirmation: 'pass')
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('は6文字以上で入力してください')
      end
    end

    context 'パスワードとパスワード（確認）が一致しない場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'Test User', email: 'test@example.com', password: 'password', password_confirmation: 'different')
        expect(user).not_to be_valid
        expect(user.errors[:password_confirmation]).to include('が一致しません')
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user = User.new(name: 'Test User', email: 'unique@example.com', password: 'password', password_confirmation: 'password')
        expect(user).to be_valid
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'ユーザを削除した場合' do
      it '紐づいているタスクも削除される' do
        user = User.create!(name: 'Test User', email: 'test@example.com', password: 'password', password_confirmation: 'password')
        user.tasks.create!(title: 'Test Task', content: 'Task content')
        expect { user.destroy }.to change { Task.count }.by(-1)
      end
    end
  end
end
