require 'rails_helper'

RSpec.describe 'Auth API', type: :request do
  let(:headers) { { 'Content-Type': 'application/json' } }

  describe 'POST /api/v1/auth/signup' do
    it 'creates a new user and returns a JWT token' do
      post '/api/v1/auth/signup', params: {
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
        phone_number: '1234567890',
        address: '221B Baker Street',
        role: 'customer'
      }.to_json, headers: headers

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('success')
      expect(json['token']).to be_present
      expect(json['user']['email']).to eq('john@example.com')
    end
  end

  describe 'POST /api/v1/auth/login' do
    let!(:user) {
      User.create!(
        name: 'Test User',
        email: 'test@example.com',
        password: 'secure123',
        phone_number: '9999999999',
        address: 'Test Street',
        role: 'customer'
      )
    }

    it 'authenticates a user and returns JWT token' do
      post '/api/v1/auth/login', params: {
        email: 'test@example.com',
        password: 'secure123'
      }.to_json, headers: headers

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('success')
      expect(json['token']).to be_present
    end

    it 'rejects invalid credentials' do
      post '/api/v1/auth/login', params: {
        email: 'test@example.com',
        password: 'wrongpassword'
      }.to_json, headers: headers

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('failed')
    end
  end

  describe 'GET /api/v1/auth/me' do
    let(:user) {
      User.create!(
        name: 'Current User',
        email: 'me@example.com',
        password: 'password',
        phone_number: '8888888888',
        address: 'Current Street',
        role: 'customer'
      )
    }
    let(:token) { JsonWebToken.encode(user_id: user.id) }

    it 'returns the current user details with valid token' do
      get '/api/v1/auth/me', headers: headers.merge('Authorization': "Bearer #{token}")

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('success')
      expect(json['data']['email']).to eq('me@example.com')
    end

    it 'fails with missing token' do
      get '/api/v1/auth/me', headers: headers

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
