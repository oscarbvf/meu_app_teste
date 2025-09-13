require 'swagger_helper'

RSpec.describe 'Posts API', type: :request do
  # /posts endpoints
  path '/posts' do
    get 'List all posts' do
      tags 'Posts'
      produces 'application/json'

      response '200', 'posts found' do
        run_test!
      end
    end

    post 'Create a post' do
      tags 'Posts'
      consumes 'application/json'
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          body: { type: :string }
        },
        required: [ 'title', 'body' ]
      }

      response '201', 'post created' do
        let(:post) { { title: 'Title', body: 'Body of the post' } }
        run_test!
      end
    end
  end

  # /posts/{id} endpoints
  path '/posts/{id}' do
    get 'Show a post' do
      tags 'Posts'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'post found' do
        let(:id) { Post.create(title: 'Test', body: 'Test body').id }
        run_test!
      end
    end

    put 'Update a post' do
      tags 'Posts'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          body: { type: :string }
        }
      }

      response '200', 'post updated' do
        let(:id) { Post.create(title: 'Test', body: 'Test body').id }
        let(:post) { { title: 'Updated Title' } }
        run_test!
      end
    end

    delete 'Delete a post' do
      tags 'Posts'
      parameter name: :id, in: :path, type: :string

      response '204', 'post deleted' do
        let(:id) { Post.create(title: 'Test', body: 'Test body').id }
        run_test!
      end
    end
  end
end
