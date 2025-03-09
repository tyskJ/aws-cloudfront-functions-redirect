.. image:: ./doc/001samune.png

=====================================================================
デプロイ - CDK -
=====================================================================

作業環境 - ローカル -
=====================================================================
* 64bit版 Windows 11 Pro
* Visual Studio Code 1.96.2 (Default Terminal: Git Bash)
* Git 2.47.1.windows.2
* AWS CLI 2.22.19.0
* nvm 1.2.2
* node v22.12.0
* npm v10.9.0
* typescript Version 5.7.2
* aws-cdk v2.174.0

フォルダ構成
=====================================================================
* `こちら <./folder.md>`_ を参照

前提条件
=====================================================================
* *AdministratorAccess* がアタッチされているIAMユーザーのアクセスキーID/シークレットアクセスキーを作成していること
* 実作業は *cdk-app* フォルダ配下で実施すること
* 以下コマンドを実行し、*admin* プロファイルを作成していること (デフォルトリージョンは *ap-northeast-1* )

.. code-block:: bash

  aws configure --profile admin

事前作業(1)
=====================================================================
1. 各種モジュールインストール
---------------------------------------------------------------------
* `GitHub <https://github.com/tyskJ/common-environment-setup>`_ を参照

事前作業(2)
=====================================================================
1. 依存関係のインストール
---------------------------------------------------------------------
.. code-block:: bash

  npm install

2. CDKデプロイメント事前準備(東京リージョン)
---------------------------------------------------------------------
.. code-block:: bash

  cdk bootstrap --profile admin

.. note::

  * *cdk-app* プロジェクトフォルダ外で実施してください。

1. CDKデプロイメント事前準備(バージニア北部リージョン)
---------------------------------------------------------------------
.. code-block:: bash

  AccountId=`aws sts get-caller-identity --query Account --profile admin --output text`
  cdk bootstrap --profile admin ${AccountId}/us-east-1

.. note::

  * *cdk-app* プロジェクトフォルダ外で実施してください。

実作業 - ローカル -
=====================================================================
1. デプロイ
---------------------------------------------------------------------
.. code-block:: bash

  cdk deploy --all \
  --context hosted_zone_id_for_alb=ALBレコードを登録するホストゾーンID \
  --context zone_apnex_name_for_alb=ALBレコードを登録するドメイン名 \
  --context issue_domain_name_for_alb=ALB用証明書のドメイン名 \
  --context fqdn_for_alb=ALB用FQDN \
  --context hosted_zone_id_for_cf=CloudFrontレコードを登録するホストゾーンID \
  --context zone_apnex_name_for_cf=CloudFrontレコードを登録するドメイン名 \
  --context issue_domain_name_for_cf=CloudFront用証明書のドメイン名 \
  --context fqdn_for_cf=CloudFront用FQDN \
  --profile admin

後片付け - ローカル -
=====================================================================
1. 環境削除
---------------------------------------------------------------------
.. code-block:: bash

  cdk destroy --all \
  --context hosted_zone_id_for_alb=ALBレコードを登録するホストゾーンID \
  --context zone_apnex_name_for_alb=ALBレコードを登録するドメイン名 \
  --context issue_domain_name_for_alb=ALB用証明書のドメイン名 \
  --context fqdn_for_alb=ALB用FQDN \
  --context hosted_zone_id_for_cf=CloudFrontレコードを登録するホストゾーンID \
  --context zone_apnex_name_for_cf=CloudFrontレコードを登録するドメイン名 \
  --context issue_domain_name_for_cf=CloudFront用証明書のドメイン名 \
  --context fqdn_for_cf=CloudFront用FQDN \
  --profile admin

.. note::

  * スタック削除後、 *DNS検証* で自動作成されたホストゾーンの *CNAMEレコード* は残る
  * そのため、不要なら手動で *CNAMEレコード* を削除すること
  * また、カスタムリソースで作成されたLambda関数のロググループも東京リージョン及びバージニア北部リージョンに残るため、不要なら手動で削除すること

参考資料
=====================================================================
ブログ
---------------------------------------------------------------------
* `[AWS CDK] 同じApp Construct内で異なるリージョンのStackをデプロイできるのか試してみた <https://dev.classmethod.jp/articles/aws-cdk-to-see-if-stacks-in-different-regions-can-be-deployed-in-the-same-app-construct/>`_
* `cdk-remote-stackでWAFv2とCloudFrontのクロスリージョン参照を実装する <https://dev.classmethod.jp/articles/cdk-remote-stack-webacl-cloudfront/>`_
* `AWS CDK公式の機能でACMとCloudFrontのクロスリージョン参照を実装する <https://dev.classmethod.jp/articles/cdk-cross-region-references-for-acm-and-cloudfront/>`_
