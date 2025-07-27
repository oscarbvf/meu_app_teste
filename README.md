# README

# My First Rails App

This is a simple Ruby on Rails project created as my first experience with the framework.  
It uses `scaffold` to implement a basic CRUD (Create, Read, Update, Delete) interface for posts.

## Purpose

The goal of this project is to:

- Learn the basics of Ruby on Rails
- Practice using `rails generate scaffold`
- Understand how models, views, controllers, routes, and migrations work together
- Experiment with unit tests for models

## Requirements

- Ruby 3.3+
- Rails 8.x
- PostgreSQL
- Node.js and Yarn (for managing frontend assets)

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

http://localhost:3000/posts

## Running Tests

1. To run model tests:

rails test

2. Make sure the test database is up to date:

rails db:test:prepare

## Features

1. Scaffold-generated Post model with fields:

titulo (string)

conteudo (text)

2. Model validations and basic unit tests

3. Simple web interface for managing posts

4. Authentication with Devise
   User authentication is implemented using Devise.
   The following Devise modules are enabled for the User model:
   :database_authenticatable – for basic authentication using email and password
   :registerable – allows users to sign up
   :recoverable – password recovery (views and controllers are ready; email delivery integration such as SendGrid is not yet configured)
   :rememberable – remembers users across browser sessions
   :validatable – provides validations for email and password

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

## What I Learned

- How to create a new Rails project

- How to use scaffold generators

- How to manage migrations and validations

- How to run tests with Minitest

- How to manage authentication with Devise

## License

This project is for learning purposes and has no specific license.
