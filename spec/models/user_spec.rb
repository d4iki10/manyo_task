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
        expect(user.errors[:email]).to include('はすでに存在します')
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'Test User', email: 'test@example.com', password: 'pass', password_confirmation: 'pass')
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('は6文字以上で入力してください')
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user = User.new(name: 'Test User', email: 'test@example.com', password: 'password', password_confirmation: 'password')
        expect(user).to be_valid
      end
    end
  end
end
