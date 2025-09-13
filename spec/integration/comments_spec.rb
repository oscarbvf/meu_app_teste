require 'swagger_helper'

RSpec.describe 'Comments API', type: :request do
  # /comments endpoints
  path '/comments' do
    get 'List all comments' do
      tags 'Comments'
      produces 'application/json'

      response '200', 'comments found' do
        run_test!
      end
    end

    post 'Create a comment' do
      tags 'Comments'
      consumes 'application/json'
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          post_id: { type: :integer },
          body: { type: :string }
        },
        required: [ 'post_id', 'body' ]
      }

      response '201', 'comment created' do
        let(:post) { Post.create(title: 'Test', body: 'Test body') }
        let(:comment) { { post_id: post.id, body: 'Great post!' } }
        run_test!
      end
    end
  end

  # /comments/{id} endpoints
  path '/comments/{id}' do
    get 'Show a comment' do
      tags 'Comments'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'comment found' do
        let(:post) { Post.create(title: 'Test', body: 'Test body') }
        let(:id) { Comment.create(post_id: post.id, body: 'Test comment').id }
        run_test!
      end
    end

    put 'Update a comment' do
      tags 'Comments'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          body: { type: :string }
        }
      }

      response '200', 'comment updated' do
        let(:post) { Post.create(title: 'Test', body: 'Test body') }
        let(:id) { Comment.create(post_id: post.id, body: 'Test comment').id }
        let(:comment) { { body: 'Updated comment' } }
        run_test!
      end
    end

    delete 'Delete a comment' do
      tags 'Comments'
      parameter name: :id, in: :path, type: :string

      response '204', 'comment deleted' do
        let(:post) { Post.create(title: 'Test', body: 'Test body') }
        let(:id) { Comment.create(post_id: post.id, body: 'Test comment').id }
        run_test!
      end
    end
  end
end
