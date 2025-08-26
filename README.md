# README

# My First Rails App

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

1. To run model tests:

   rails test

2. Make sure the test database is up to date:

   rails db:test:prepare

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

   The application currently uses Devise's default views (no customization).

   Only authenticated users can create, edit, or delete posts.
   This is enforced via before_action :authenticate_user! in the PostsController.

5. Authorization with Pundit
   This application uses Pundit. Policies are defined to control user access to specific resources and actions based on their roles or ownership. Unauthorized actions trigger a flash alert and redirect the user to a safe location.

   To ensure security:
   - ApplicationController includes Pundit and handles Pundit::NotAuthorizedError.
   - Controllers call authorize(resource) to enforce policy checks.
   - Only authenticated users (via Devise) can access protected actions.
   - Example policy: Only the author of a post can edit or delete it.

   Note: The app also uses Turbo (via Hotwire) for faster navigation without full page reloads, which is fully compatible with Pundit’s redirection and flash messages.


## Development Practices

### Environment Variables
This project uses the `dotenv` gem to manage environment variables securely and efficiently. Configuration values such as API keys, secret tokens, and other sensitive data are stored in a `.env` file, which is excluded from version control. This allows different environments (development, staging, production) to use separate configurations without exposing secrets.

### Code Style
This project uses `Rubocop` to enforce Ruby style guidelines and maintain code consistency. Running Rubocop helps identify and correct formatting issues, unused variables, bad naming, and other common problems. This contributes to a more readable, maintainable, and professional codebase.

## Running the Application with Docker

This project provides Docker configuration to simplify setup and development. You can run the application in containers without installing Ruby, PostgreSQL, or Node.js locally.

### Steps:

1. Build and start the containers:
   docker-compose up --build

2. Run database setup inside the container:
   docker-compose exec web bin/rails db:setup

3. Access the application in your browser at http://localhost:3000


## What I Learned

- How to create a new Rails project

- How to use scaffold generators

- How to manage migrations and validations

- How to run tests with Minitest

- How to manage authentication with Devise

- How to configure, build and run the application with Docker

## License

This project is for learning purposes and has no specific license.
