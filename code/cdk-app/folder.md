# フォルダ構成

- フォルダ構成は以下の通り

```
.
`-- cdk-app
    |-- bin
    |   `-- cdk-app.ts                        CDK App定義ファイル
    |-- lib
    |   |-- assets
    |   |   |-- function.js                   CloudFront Functionsコード
    |   |   `-- userdata.sh                   UserDataスクリプト
    |   |-- construct                         コンストラクト
    |   |   |-- acm.ts                          ACM
    |   |   |-- alb.ts                          ALB
    |   |   |-- cloudfront.ts                   CloudFront
    |   |   |-- ec2.ts                          EC2
    |   |   |-- iam.ts                          IAM
    |   |   |-- network.ts                      Network
    |   |   `-- s3.ts                           S3
    |   |-- html                              静的ウェブサイトホスティング用ドキュメント
    |   |   |-- error.html
    |   |   `-- index.html
    |   |-- json
    |   |   `-- bucket-policy.json            S3バケットポリシー
    |   `-- stack
    |       |-- TokyoStack.ts                 東京リージョンスタック
    |       `-- VirginiaStack.ts              バージニア北部スタック
    `-- parameter.ts                          環境リソース設定値定義ファイル
```
