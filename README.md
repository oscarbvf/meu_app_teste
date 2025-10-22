# README

# My First Rails App

[![CI](https://github.com/oscarbvf/meu_app_teste/actions/workflows/ci.yml/badge.svg)](https://github.com/oscarbvf/meu_app_teste/actions/workflows/ci.yml)
[![Deploy on Railway](https://img.shields.io/badge/Deployed%20on-Railway-0B0D0E?logo=railway&logoColor=white)](https://railway.app/project/dee0719e-d6c5-4267-bc83-60e98b3234a5)

This is a simple Ruby on Rails project created as my first experience with the framework.  
It uses `scaffold` to implement a basic CRUD (Create, Read, Update, Delete) interface for posts and comments.

## Purpose

The goal of this project is to:

- Learn the basics of Ruby on Rails
- Practice using `rails generate scaffold`
- Understand how models, views, controllers, routes, and migrations work together
- Experiment with unit tests for models

## Requirements

- Ruby 3.3+
- Rails 8.x
- PostgreSQL 17.5
- Importmap (for frontend assets with Turbo and Stimulus)
- Devise (authentication)
- Pundit (authorization)
- JWT (API token authentication)
- RSpec (for API testing)
- Rswag (Swagger documentation for API)

## Getting Started

1. Clone the repository:

   git clone https://github.com/oscarbvf/meu_app_teste.git
   cd meu_app_teste

2. Install dependencies:

   bundle install
   yarn install

3. Create and migrate the database:

   rails db:create
   rails db:migrate

4. Start the server:

   rails server

5. Open your browser and go to:

   http://localhost:3000

## Running Tests

1. To run Web application tests (Minitest):

   rails test
   rails db:test:prepare

2. To run API tests (RSpec):

   bundle exec rspec


## Features

1. Scaffold-generated models with fields:

   Post:
   - title (string)
   - content (text)

   User:
   - e-mail (string)
   - password (string)

   Comment:
   - body (text)
   - user
   - post


2. Model validations and basic unit tests
   Basic unit tests and integration tests are included using Minitest to ensure models, validations, and CRUD operations function correctly.

3. Simple web interface for managing Posts and Comments

4. Authentication with Devise
   User authentication is implemented using Devise.
   The following Devise modules are enabled for the User model:
   - database_authenticatable: for basic authentication using email and password
   - registerable: allows users to sign up
   - recoverable: password recovery (views and controllers are ready; email delivery integration such as SendGrid is not yet configured;
   Background job processing with **SolidQueue** (default Rails 8 queue adapter))
   - rememberable: remembers users across browser sessions
   - validatable: provides validations for email and password

   Only authenticated users can create, edit, or delete posts.
   This is enforced via before_action :authenticate_user! in the PostsController.

   In development, password reset emails are delivered using letter_opener, allowing you to preview them directly in the tmp/letter_opener folder instead of sending real emails.

5. Authorization with Pundit
   This application uses Pundit. Policies are defined to control user access to specific resources and actions based on their roles or ownership. Unauthorized actions trigger a flash alert and redirect the user to a safe location.

   To ensure security:
   - ApplicationController includes Pundit and handles Pundit::NotAuthorizedError.
   - Controllers call authorize(resource) to enforce policy checks.
   - Only authenticated users (via Devise) can access protected actions.
   - Example policy: Only the author of a post can edit or delete it.

6. User Experience Enhancements:
   The entire user interface, including posts, comments, and navigation, is styled consistently using Tailwind CSS for modern, responsive layouts.

   The app uses Turbo (via Hotwire) for faster navigation without full page reloads, which is fully compatible with Pundit’s redirection and flash messages. Posts and Comments leverage Turbo Frames and Stimulus controllers for inline updates, dynamic forms, and real-time UI enhancements.

   The application uses customized Devise views for Sign In, Sign Up, and Forgot Password flows. This customization improves the user experience while preserving all Devise functionality, such as secure login, registration, and password reset.

   The application features custom real-time toast notifications using a Stimulus controller and Turbo Streams. Flash messages (notice, alert, etc.) are rendered as <turbo-stream> elements with a custom notify action, which dispatches a browser event captured by the Stimulus notifications_controller. This approach allows dynamic, temporary notifications to appear on the screen without full-page reloads, automatically fading out after a few seconds for a smooth user experience.

## API v1

The application exposes a RESTful API for Posts and Comments under /api/v1.
The API uses JWT tokens for authentication and Pundit for authorization.

Base URL
http://localhost:3000/api/v1

Authentication

Login: POST /api/v1/auth/login

Parameters: email, password

Response:

{
  "token": "<jwt_token>",
  "user": {
    "id": 1,
    "email": "user@example.com"
  }
}


Include the JWT token in the Authorization header for protected endpoints:

Authorization: Bearer <jwt_token>

Posts Endpoints:
- GET /posts → list all posts
- GET /posts/:id → show a single post
- POST /posts → create a post (authenticated)
- PATCH /posts/:id → update a post (owner only)
- DELETE /posts/:id → delete a post (owner only)

Comments Endpoints:
- GET /posts/:post_id/comments → list comments for a post
- POST /posts/:post_id/comments → create a comment (authenticated)
- PATCH /comments/:id → update a comment (owner only)
- DELETE /comments/:id → delete a comment (owner only)

Sample Responses

GET /posts

[
  {
    "id": 1,
    "title": "My First Post",
    "content": "Post content here",
    "user_id": 1,
    "created_at": "2025-09-09T12:00:00Z"
  }
]


Error Response

{
  "error": "Unauthorized",
  "status": 401
}

Example cURL Requests

Login

curl -X POST http://localhost:3000/api/v1/auth/login \
-H "Content-Type: application/json" \
-d '{"email": "user@example.com", "password": "password"}'


Get posts with JWT

curl http://localhost:3000/api/v1/posts \
-H "Authorization: Bearer <jwt_token>"


## Swagger Documentation

The API is fully documented with Swagger using rswag.

Swagger UI can be accessed in development at:

http://localhost:3000/api-docs


The documentation includes all endpoints for Posts and Comments, request parameters, responses, and error messages.

Rswag is configured to generate the OpenAPI spec automatically from the RSpec API tests.


## Development Practices

### Environment Variables
This project uses the `dotenv` gem to manage environment variables securely and efficiently. Configuration values such as API keys, secret tokens, and other sensitive data are stored in a `.env` file, which is excluded from version control. This allows different environments (development, staging, production) to use separate configurations without exposing secrets.

### Code Style
This project uses `Rubocop` to enforce Ruby style guidelines and maintain code consistency. Running Rubocop helps identify and correct formatting issues, unused variables, bad naming, and other common problems. This contributes to a more readable, maintainable, and professional codebase.

### Backgroud Jobs
Background job processing is handled via SolidQueue, following Rails defaults. Currently, jobs are used only for email delivery, but the infrastructure supports other future asynchronous tasks.


## Running the Application with Docker

This project provides Docker configuration to simplify setup and development. You can run the application in containers without installing Ruby, PostgreSQL, or Node.js locally.

### Steps:

1. Build and start the containers:
   docker-compose up --build

2. Run database setup inside the container:
   docker-compose exec web bin/rails db:setup

3. Access the application in your browser at http://localhost:3000


## What I Learned

- How to create a full-featured Rails application with scaffold-generated CRUD for posts and comments

- How to implement authentication with Devise and customize its views for a consistent, modern UI using Tailwind CSS

- How to add real-time toast notifications with Turbo Streams and Stimulus controllers

- How to enhance user experience with Turbo Frames and Stimulus for dynamic forms and inline updates

- How to implement authorization policies with Pundit

- How to implement JWT-based API authentication

- How to create Swagger documentation with Rswag

- How to implement basic RSpec tests for API

- How to write basic tests with Minitest to ensure model validations and CRUD operations work correctly

- How to configure and run the application with Docker and manage dependencies with Importmap

## Deployment and Production Configuration

This application was successfully deployed to Railway, as part of a learning exercise to understand production deployment workflows for Ruby on Rails applications.

### Production Environment Highlights

- Platform: Railway (temporary deployment for learning purposes)
- Database: PostgreSQL (managed by Railway)
- Runtime: Ruby 3.3 + Rails 8
- Web Process: Defined via Procfile (bundle exec rails server -p $PORT -b 0.0.0.0)
- Environment Variables: Managed via Railway’s built-in configuration panel
- Migrations: Executed using railway run rake db:migrate
- Build Configuration: Default Railway buildpacks (no Dockerfile required)

This deployment validated that the application can run in a cloud production environment, with a PostgreSQL database and persistent data layer.
The environment has since been removed to avoid charges, but the full setup is documented for reproducibility.

## Continuous Integration (CI)

This project includes a Continuous Integration (CI) pipeline configured with GitHub Actions to ensure code quality, consistency, and reliability.

### Workflow Overview

The workflow file .github/workflows/ci.yml is triggered automatically on:

Every push or pull request to the main branch

Manual runs (via the “Run workflow” button in the GitHub Actions tab)

### Main Steps

1. Set up environment

- Runs on the latest Ubuntu runner
- Installs Ruby 3.3, Node.js, Yarn, and PostgreSQL service
- Caches gems to speed up subsequent builds

2. Install dependencies

bundle install
yarn install

3. Prepare the database

rails db:create db:migrate

4. Run tests

- Executes Minitest for the web application
- Executes RSpec for API tests
- Ensures that all tests pass before allowing merges into main

5. Linting and Code Style

- Runs Rubocop to enforce Ruby style conventions
- Fails the workflow if style violations or syntax errors are found

### Benefits

- Automatic validation: Every commit and pull request is tested automatically.
- Consistent quality: Prevents broken builds or untested code from being merged.
- Faster development: Developers receive immediate feedback on test results.
- Reproducibility: Ensures that the application can be set up and tested identically across environments.

## Continuous Deployment (CD)

This project uses **Continuous Deployment (CD)** integrated with [Railway](https://railway.app).  
Every time a pull request is merged into the `master` branch, the application is automatically built and deployed to the production environment.

The deployment process is fully automated through Railway’s GitHub integration:
- Detects new commits on the `master` branch  
- Builds and deploys the application using the latest code  
- Manages environment variables securely within the Railway platform  

This setup ensures that the production environment is always up to date with the latest tested and validated code, maintaining consistency between development and deployment stages.

## License

This project is for learning purposes and has no specific license.
