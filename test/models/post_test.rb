require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "é válido com título e conteúdo" do
    post = Post.new(titulo: "Olá Mundo", conteudo: "Esse é meu primeiro post!")
    assert post.valid?
  end

  test "é inválido sem título" do
    post = Post.new(titulo: nil, conteudo: "Conteúdo sem título")
    assert_not post.valid?
    assert_includes post.errors[:titulo], "can't be blank"
  end

  test "é inválido sem conteúdo" do
    post = Post.new(titulo: "Título sem conteúdo", conteudo: nil)
    assert_not post.valid?
    assert_includes post.errors[:conteudo], "can't be blank"
  end
end
