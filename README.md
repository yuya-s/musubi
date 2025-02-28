# MUSUBI WEBSITE

このリポジトリは GitHub Pages でホストされる Jekyll サイトです。ローカル環境で Jekyll を起動し、プレビューする方法を説明します。

## 🚀 環境のセットアップ

### 1. 必要なツールをインストール
Jekyll を動作させるために Ruby と Bundler が必要です。

#### 🔹 macOS (M1/M2 含む)
```bash
# Homebrew を使用して chruby と ruby-install をインストール
brew install chruby ruby-install

# Ruby をインストール
ruby-install ruby 3.4.1

# シェルの設定を更新
echo 'source /opt/homebrew/opt/chruby/share/chruby/chruby.sh' >> ~/.zshrc
echo 'source /opt/homebrew/opt/chruby/share/chruby/auto.sh' >> ~/.zshrc
echo "chruby ruby-3.4.1" >> ~/.zshrc # run 'chruby' to see actual version
source ~/.zshrc

# Ruby のバージョンを確認
ruby -v # ruby 3.4.1 (2024-12-25 revision 48d4efcb85) +PRISM [arm64-darwin24]

# Bundler をインストール
gem install bundler
```

#### 🔹 Windows (※ChatGPT出力そのままで実動作は未確認)
Windows では WSL2 (Ubuntu) を使用することを推奨します。
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y ruby-full build-essential zlib1g-dev

# Bundler をインストール
gem install bundler
```

### 2. リポジトリをクローン
```bash
git clone https://github.com/Ferix-Inc/musubi-website-front.git
cd musubi-website-front
```

### 3. 依存関係をインストール
```bash
bundle install
```

## 🚀 Jekyll を起動
以下のコマンドでローカルサーバーを起動できます。
```bash
bundle exec jekyll serve --baseurl=""
```

### 🔍 サイトのプレビュー
ブラウザで [http://localhost:4000](http://localhost:4000) にアクセスしてください。
Jekyllは静的サイトジェネレータのため、HTML等の変更後は、ブラウザでの更新操作が必要です。

## 🔄 API データ取得 & GitHub Actions 自動ビルド

本プロジェクトでは、microCMS などの外部 API からデータを取得し、Jekyll のビルド時に `_data/news.json` を更新します。  
**GitHub Actions を使って自動化** しています。

### 📌 `_data/news.json`について
`_data/news.json`の内容を、HTMLから`{{site.data.news}}`という形で取得できます。([Liquid](https://jekyllrb-ja.github.io/docs/liquid/)というテンプレート言語です。)
`jekyll serve`中にJSONファイルの中身を書き換えて更新すれば、確認したいデータで動作確認できます。
microCMSの管理画面のAPIプレビューで取得したレスポンスデータで、JSONファイルの中身を上書きするという使い方もあります。

### 🚀 GitHub Actions による自動 API データ取得
GitHub Actions を使用して、以下のタイミングで API データを取得し、`_data/news.json` を更新してから、Jekyll をビルドします。  

✅ `master` ブランチにマージされたとき  
✅ microCMS の Webhook 通知を受け取ったとき  

`.github/workflows/build.yml` で定義されています。
APIキーは`github-pages`のEnvironmentsでSecretsとして保存し、GitHub Actions実行時に読み込んでいます。

### 📌 ローカルで API データ取得を確認する方法(`_plugin/microcms.rb`の動作確認)

#### 環境変数の設定
API キーは `.env` ファイルに設定し、`dotenv` を利用します。  
`.env` ファイル（※Git に含めない）を作成し、以下のように記述してください。

```
MICROCMS_API_KEY=your_api_key_here
```

また、dotenv読み込み処理追加をします。
（GitHub Actionsを動かすのに不要なので、mainにはマージしていません）

Gemfile:
  ```ruby:Gemfile
  gem "dotenv", "~> 3.1"
  ```

_plugins/microcms.rb:
  ```ruby:_plugins/microcms.rb
  require 'dotenv'

  Dotenv.load
  ```

#### 実行
以下のコマンドを実行してください。

```bash
bundle exec ruby _plugins/microcms.rb
```

## 🔍 Rubyコード品質チェック（RuboCop の使用方法）

本プロジェクトでは、`_plugins`内のRuby のコード品質を保つために `RuboCop` を使用しています。  
以下の手順で `RuboCop` を実行し、コードのフォーマットやリントエラーをチェックできます。

### 📌 RuboCop の実行
```bash
bundle exec rubocop
```
または（Bundler を使わない場合）
```bash
rubocop
```

### 🚨 CI/CD で RuboCop を実行
GitHub Actions で RuboCop の実行が、`.github/workflows/rubocop.yml` で定義されています。

## ❓ トラブルシューティング

- `jekyll: command not found` と表示される場合：
  ```bash
  bundle install
  ```

- `Could not find 'jekyll' in any of the sources` と表示される場合：
  ```bash
  bundle exec jekyll serve
  ```

## 🎯 デプロイ
GitHub Pages にデプロイするには、以下のブランチに変更をマージしてください。
- `master`

デプロイ後、[https://ferix-inc.github.io/musubi-website-front/](https://ferix-inc.github.io/musubi-website-front/) にアクセスして確認できます。

## 🔐 本番環境設定手順
GitHub Pages 配信元リポジトリ変更時の設定手順は以下に記載しています。
[本番環境設定手順 - GitHub Pages & microCMS](docs/github_pages_microcms_setup.md)

---

## ✉️ 連絡先
フェリックスの担当者、もしくは下記メールアドレスまでご連絡ください。
メールアドレス: info@ferix.jp
