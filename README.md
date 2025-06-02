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

## What I Learned

- How to create a new Rails project

- How to use scaffold generators

- How to manage migrations and validations

- How to run tests with Minitest

## License

This project is for learning purposes and has no specific license.
