# 本番環境設定手順 - GitHub Pages & microCMS

このドキュメントでは、microCMSを使ってニュースを管理し、GitHub Pagesでホスティングするための設定手順を説明します。

## 前提条件
- GitHubアカウント(リポジトリのadminアクセス権)
- microCMSアカウント(管理者権限)
- GitHub Pagesのリポジトリが既に作成されていること
- microCMSにおいてニュースコンテンツが設定されていること

---

## 1. 開発会社からソースコードを受領

開発会社から提供されたソースコードをGitHubリポジトリにアップロードします。

---

## 2. microCMS Webhook設定

microCMSでの記事の更新をGitHub Pagesに反映させるために、Webhookを設定します。
microCMSサービスの変更によって手順が変わる可能性もあるため、参考資料として、以下のドキュメントも合わせて参照してください。一部抜粋して下記に記載しています。
[【コンテンツのWebhook連携】GitHub Actionsの設定方法について](https://help.microcms.io/ja/knowledge/webhook-github-actions-settings)
mircoCMSから更新するコンテンツ(API)が複数ある場合は、すべてのコンテンツ(API)でWebhook設定を行なってください。

### 手順：

1. ワークフローファイルはソースコードに含まれていますので、修正不要です。
2. GitHubでトークンを作成します。Tokens（classic）での手順を記載します。
    1. GitHubのユーザー設定ページ（https://github.com/settings/profile）にアクセスします。
    2. ユーザー設定ページにて、左カラムの最下部にある「Developer settings」（https://github.com/settings/apps）にアクセスします。
    3. 左カラムから「Personal access tokens」のメニューを押下し、Tokens（classic）を押下します。
    4. トークン一覧画面にて「Generate new token」ボタンを押下します。
    5. 「New personal access token（classic）」の画面で、以下の情報を入力します。
        - Note（必須）: 任意の説明を入力してください。
        - Expiration（必須）: 任意の有効期限を選択してください。
            - 有効期限が切れると、再度トークンを作成し、microCMSのWebhook設定を更新する必要があります。
            - 有効期限なしも設定可能ですが、セキュリティ的には推奨されていません。
    6. 次に、「Select scopes」セクションへ進み、「repo」にチェックをいれます。
    7. ページ下部の「Generate token」ボタンを押下します。
    8. トークンの一覧画面に戻り、作成したばかりのトークンが表示されているので、コピーして保存しておきます。トークンの作成はここで終了です。
        - トークンはあとから再表示できません。忘れた場合は、再度作成が必要です。
3. **microCMS**にログインし、コンテンツが含まれている「サービス」を開きます。
4. 左側のメニューからコンテンツ（API）を選択し、右側の(歯車のマーク)API設定を選択します。
5. 左側のメニューから「Webhooks」を選択し、GitHub Actions Webhookが既に作成されているので選択すると、設定が開きます。
6. 以下の情報を本番環境用GitHubリポジトリの内容に変更します:
   - **GitHubトークンを設定してください。**: 手順2.で取得したトークンを貼ります。
   - **リポジトリのユーザー名を入力してください。通常、https://github.com/:user/:repoの :user 部分です。**: 本番環境用GitHubリポジトリURLの`:user`部分を入力してください
   - **リポジトリ名を入力してください。通常、https://github.com/:user/:repoの :repo 部分です。**: 同様に、URLの`:repo`部分を入力してください
7. トリガーイベント名は手順1.のソースコード内に記載しているため、変更しないでください。
8. 「通知タイミングの設定」セクションにて、任意の通知タイミングを選択してください。設定した通知タイミングでGitHub Pagesが更新されます。
9. 設定を保存します。
10. mircoCMSから更新するコンテンツ(API)が複数ある場合は、手順4.~9.を各コンテンツで繰り返します。設定内容は同じです。

---

## 3. GitHub ActionsのSecretsにmicroCMS APIキーを設定

microCMSのAPIキーをGitHubのSecretsに保存し、GitHub Actionsから利用できるようにします。
GitHubやmicroCMSサービスの変更によって手順が変わる可能性もあるため、参考資料として、以下のドキュメントも合わせて参照してください。
[GitHub Actions でのシークレットの使用 \- GitHub Docs](https://docs.github.com/ja/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-an-environment)
[APIキー（APIの認証と権限管理）｜microCMSドキュメント](https://document.microcms.io/content-api/x-microcms-api-key)

### 手順：
1. microCMSのAPIキーを取得します。
    1. **microCMS**にログインし、コンテンツが含まれている「サービス」を開きます。
    2. 左側のメニューから「権限管理」> 「1個のAPIキー」を選択します。
    3. APIキーの一部が表示されているので、横のコピーマーク（紙が2枚重なっているマーク）をクリックしてコピーします。
2. GitHubにログインし、本番環境用GitHubリポジトリにアクセスします。
3. GitHubリポジトリのトップページで、「Settings」を選択します。
4. 左側のメニューで「Security」セクションの「Secrets and variables」をクリックし、「Actions」を選択します。
5. 「Secret」 タブが選択されていることを確認します。
6. 「Manage environment secrets」を選択します。
7. 「github-pages」の環境を選択します。なければ「New environment」から作成してください。
8.  「Environment secrets」セクションで「Add environment secret」を選択して、以下の情報を入力します:
   - **Name**: `MICROCMS_API_KEY`
   - **Value**: 手順1. でコピーしたmicroCMSのAPIキー
9.  設定を保存します。

---

## 4. GitHub Pages サイトの公開元を GitHub Actions ワークフローに変更する

GitHub Pagesの更新が、microCMSで記事が更新されたときに動作するGitHub Actionsと連動するように変更します。
GitHubサービスの変更によって手順が変わる可能性もあるため、参考資料として、以下のドキュメントも合わせて参照してください。
[GitHub Pages サイトの公開元を設定する \- GitHub Docs](https://docs.github.com/ja/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site#%E3%82%AB%E3%82%B9%E3%82%BF%E3%83%A0-github-actions-%E3%83%AF%E3%83%BC%E3%82%AF%E3%83%95%E3%83%AD%E3%83%BC%E3%81%AB%E3%82%88%E3%82%8B%E5%85%AC%E9%96%8B)

### 手順：
1. GitHubにログインし、本番環境用GitHubリポジトリにアクセスします。
2. GitHubリポジトリのトップページで、「Settings」を選択します。
3. 左側のメニューで「Code and automation」セクションから「Pages」を選択します。
4. 「Build and deployment」セクションの「Source」を「GitHub Actions」に変更します。

---

## 5. 最終確認

1. microCMSで記事を追加・更新・削除して、Webhooksを動作させます。
2. GitHub Actionsがトリガーされ、変更がGitHub Pagesに反映されていることを確認します。

---

以上が、GitHub PagesにmicroCMSを連携するための本番環境設定手順です。
