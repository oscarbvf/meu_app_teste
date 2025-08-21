require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "Valid with title and content" do
    post = Post.new(titulo: "Hello", conteudo: "This is my first post!")
    assert post.valid?
  end

  test "It's not valid without title" do
    post = Post.new(titulo: nil, conteudo: "Content without title")
    assert_not post.valid?
    assert_includes post.errors[:titulo], "can't be blank"
  end

  test "It's not valid without content" do
    post = Post.new(titulo: "Title without content", conteudo: nil)
    assert_not post.valid?
    assert_includes post.errors[:conteudo], "can't be blank"
  end
end
