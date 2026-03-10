# CLAUDE.md

このファイルは Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイドです。

## プロジェクト概要

Kashiraku は個人菓子店向けの原価計算・アレルゲン自動判定・
食品表示ラベル生成Webアプリ。
Ruby on Rails 8.0 + PostgreSQL 17。
ロケールは日本語 (ja)、タイムゾーンは Tokyo。

## 技術スタック

- Ruby 3.4 / Rails 8.0 / PostgreSQL 17
- Hotwire (Turbo + Stimulus) / Tailwind CSS / Importmap
- Solid Queue, Solid Cache, Solid Cable（Redis 不要）
- Propshaft（アセットパイプライン）
- RSpec + FactoryBot / RuboCop (omakase) / Brakeman

## 開発環境（Docker）

```bash
docker compose up -d                    # コンテナ起動
docker compose exec web <command>       # web コンテナ内でコマンド実行
docker compose down                     # コンテナ停止
docker compose build web                # Gemfile 変更後にイメージ再ビルド
```

## 主要コマンド（web コンテナ内で実行）

```bash
# サーバー
bundle exec rails server -b 0.0.0.0

# データベース
bin/rails db:create
bin/rails db:migrate
bin/rails db:schema:load

# テスト
bundle exec rspec
bundle exec rspec spec/models/user_spec.rb       # 単一ファイル
bundle exec rspec spec/models/user_spec.rb:10     # 特定行のテスト

# Lint
bundle exec rubocop
bundle exec rubocop -a                            # 自動修正
bundle exec brakeman --no-pager
```

## アーキテクチャ

- **Dockerfile**: 開発用（ruby:3.4 フルイメージ）。レイヤーキャッシュのため Gemfile を先にコピーして bundle install。
- **docker-compose.yml**: `web`（Rails, ポート 3000）+ `db`（PostgreSQL 17, ポート 5432）。ホストボリュームマウントでコード変更を即時反映。
- **entrypoint.sh**: 起動前に server.pid を削除。

## コードスタイル・ジェネレータ

- RuboCop は `rubocop-rails-omakase` をベースに `rubocop-rspec`、`rubocop-factory_bot` プラグインを使用。
- ジェネレータはアセット、ヘルパー、ルーティング、ビュー spec、ヘルパー spec、ルーティング spec、fixtures、システムテストをスキップ。
- リクエスト spec は有効。

## CI

GitHub Actions で PR 時のみ実行。2つのジョブが並列実行:
- **lint**: RuboCop + Brakeman
- **test**: PostgreSQL 17 サービスコンテナを使った RSpec

## ブランチ・コミット規約

- ブランチ名: feature/#Issue番号-短い説明
  （例: feature/#8-materials-crud）
- バグ修正: fix/#Issue番号-短い説明
- コミットメッセージは日本語、50文字以内で、プレフィックスをつける（例: feat: Materialモデルとマイグレーションを追加）
  - feat: 新機能
  - fix: バグ修正
  - docs: ドキュメント
  - test: テスト
  - chore: 設定・雑務
- PRには Closes #Issue番号 を含める

## コーディング規約

- コントローラーは薄く保つ。ロジックはモデルへ
- 全クエリを current_user 起点にする（他ユーザーのデータにアクセス不可）
- N+1 クエリを避ける。関連データは includes で事前読み込み
- マジックナンバーは定数化する
- メソッドは10行以内を目安。超えたら分割を検討
- コメントは原則書かない。コードで意図を表現する
- 「なぜそうしてるか」が法律やビジネスルールに起因する場合のみコメントを書く

## バックエンド

- ビジネスロジックはモデルに集約
- バリデーションはモデルに書く
- コールバック（before_save等）は副作用を最小限にする
- decimal 型は金額・数量に使用（integer にしない）

## フロントエンド

- Hotwire（Turbo Frames + Stimulus）で部分更新
- TailwindCSS のユーティリティクラスのみ使用
- カスタムCSS は原則書かない
- Stimulus コントローラーは1つの責務に絞る
- ビューにロジックを書かない。モデルのメソッドを呼ぶ
- ヘルパーは表示フォーマットのみ（金額表示、日付表示等）

## テスト

- RSpec + FactoryBot を使用
- モデルスペック: バリデーション、計算ロジック、スコープ
- リクエストスペック: 主要な導線、認証、アクセス制御
- テストは機能実装と同じPRに含める
- FactoryBot のファクトリは spec/factories/ に配置