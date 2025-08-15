# syntax=docker/dockerfile:1

# Define a versão do Ruby
ARG RUBY_VERSION=3.3.8
FROM ruby:$RUBY_VERSION-slim AS base

# Diretório da aplicação dentro do container
WORKDIR /rails

# Instala dependências básicas do sistema
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        build-essential libpq-dev curl libjemalloc2 libvips sqlite3 git && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Configura variáveis de ambiente para bundler
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Estágio de build para reduzir tamanho da imagem final
FROM base AS build

# Instala pacotes adicionais para build de gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copia Gemfile e Gemfile.lock e instala gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copia o código da aplicação
COPY . .

# Precompila bootsnap para acelerar boot do Rails
RUN bundle exec bootsnap precompile app/ lib/

# Ajusta arquivos binários para Linux
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# Imagem final
FROM base

# Copia gems e código da aplicação
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Cria usuário rails e define permissões
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

# Usa usuário não-root
USER 1000:1000

# Define o entrypoint absoluto
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expõe a porta 3000 para Rails
EXPOSE 3000

# Comando default para iniciar servidor Rails
CMD ["bash", "-c", "bundle exec rails server -b 0.0.0.0 -p 3000"]
