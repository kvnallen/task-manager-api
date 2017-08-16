require 'rails_helper'

RSpec.describe 'Task API' do
  before { host! 'api.taskmanager.dev' }
  let(:user) { create(:user) }
  let(:headers) do
    {
       "Accept" => "application/vnd.taskmanager.v1",
       'Content-type' => 'application/json',
       'Authorization' => user.auth_token
    }
  end

  describe 'GET /tasks' do
    before do
      create_list(:task, 5, user_id: user.id)
      get '/tasks', params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 5 tasks from database' do
      expect(json_body[:tasks].count).to eq(5)
    end
  end

  describe 'GET /tasks/:id' do
    
    let(:task) { create(:task, user_id: user.id) }
    before { get "/tasks/#{task.id}", params: {}, headers: headers }
    
    it 'return status 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the json for the task' do
      expect(json_body[:id]).to eq(task.id)
    end

  end

  describe 'POST /task' do
    before do
      post '/tasks', params: { task: task_params }.to_json, headers: headers 
    end
   
    context 'when the params are valid' do
      let(:task_params) { attributes_for(:task) }
      
      it 'it returns status code 201' do
        expect(response).to have_http_status(201)
      end
      
      it 'saves the task in the database' do
        expect( Task.find_by(title: task_params[:title]) ).not_to be_nil
      end
      
      it 'returns the json for the created task ' do
        expect(json_body[:title]).to eq(task_params[:title])
      end
      
      it 'assings the task for the current user' do
        expect(json_body[:user_id]).to eq(user.id)
      end
      
    end
    
    context 'when the params are invalid' do
      let(:task_params) { attributes_for(:task, title: ' ') }
      
      it 'it returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'does not save the task in the database' do
        expect( Task.find_by(title: task_params[:title]) ).to be_nil
      end

      it 'returns the json error for title' do
        expect(json_body[:errors]).to have_key(:title)
      end

    end

    describe 'PUT /tasks/:id' do
      let!(:task) { create(:task, user_id: user.id) }
      before do
        put "/tasks/#{task.id}", params: { task: task_params }.to_json, headers: headers
      end

      context 'when the params are valid' do
        let(:task_params) { { title: 'New task title' } }

        it 'return status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns the json for the updated task' do
          expect(json_body[:title]).to eq(task_params[:title])
        end

        it 'updates the task in database' do
          expect(Task.find_by(title: task_params[:title])).not_to be_nil
        end
      end

      context 'when the params are invalid' do
        let(:task_params) { { title: ' ' } }

        it 'return status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns the json with errors for title' do
          expect(json_body[:errors]).to have_key(:title)
        end

        it 'updates the task in database' do
          expect(Task.find_by(title: task_params[:title])).to be_nil
        end

      end
    end
  end

end