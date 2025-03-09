/*
╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ CloudFront Functions redirect Stack - Cloud Development Kit cloudfront.ts                                                                          ║
╠════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║ This construct creates an L2 Construct CloudFront Distribution and Alias RecordSet.                                                                ║
╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
*/
import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";
import * as cloudfront from "aws-cdk-lib/aws-cloudfront";
import * as cloudfront_origins from "aws-cdk-lib/aws-cloudfront-origins";
import * as s3 from "aws-cdk-lib/aws-s3";
import * as s3_deployment from "aws-cdk-lib/aws-s3-deployment";
import * as acm from "aws-cdk-lib/aws-certificatemanager";
import * as route53 from "aws-cdk-lib/aws-route53";
import * as route53_targets from "aws-cdk-lib/aws-route53-targets";
import { bucketInfo } from "../../parameter";
import * as path from "path";

export interface CloudFrontProps extends cdk.StackProps {
  bucket: bucketInfo;
  cfFqdn: string;
  cfCert: acm.Certificate;
  hosted_zone_id: string;
  zone_apnex_name: string;
}

export class CloudFront extends Construct {
  constructor(scope: Construct, id: string, props: CloudFrontProps) {
    super(scope, id);

    // S3 Bucket
    const bucket = new s3.Bucket(this, "RedirectBucket", {
      bucketName: props.bucket.bucketName,
      autoDeleteObjects: props.bucket.autoDeleteObjects,
      bucketKeyEnabled: props.bucket.bucketKeyEnabled,
      encryption: s3.BucketEncryption.S3_MANAGED,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
      blockPublicAccess: new s3.BlockPublicAccess({
        blockPublicAcls: props.bucket.blockPublicAccess.blockPublicAcls,
        ignorePublicAcls: props.bucket.blockPublicAccess.ignorePublicAcls,
        blockPublicPolicy: props.bucket.blockPublicAccess.blockPublicPolicy,
        restrictPublicBuckets:
          props.bucket.blockPublicAccess.restrictPublicBuckets,
      }),
    });

    // OAC
    const oac = new cloudfront.S3OriginAccessControl(this, "OAC", {
      originAccessControlName: "cf-oac-s3",
      description: "OAC for S3 bucket",
      signing: cloudfront.Signing.SIGV4_NO_OVERRIDE,
    });

    // s3Origin
    const s3Origin = cloudfront_origins.S3BucketOrigin.withOriginAccessControl(
      bucket,
      {
        originAccessControl: oac,
        originId: bucket.bucketName,
      }
    );

    // distribution
    const ditribution = new cloudfront.Distribution(this, "Distri", {
      enabled: true,
      defaultRootObject: "index.html",
      certificate: acm.Certificate.fromCertificateArn(
        this,
        "ImportCert",
        props.cfCert.certificateArn
      ),
      defaultBehavior: {
        origin: s3Origin,
        viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
      },
      errorResponses: [
        {
          httpStatus: 404,
          ttl: cdk.Duration.seconds(10),
          responseHttpStatus: 200,
          responsePagePath: "/error.html",
        },
      ],
      domainNames: [props.cfFqdn],
    });

    // Object Uploads
    new s3_deployment.BucketDeployment(this, "UpdateHtml", {
      destinationBucket: bucket,
      sources: [
        s3_deployment.Source.asset(path.join(`${__dirname}`, "../html")),
      ],
    });

    // import hosted zone
    const hosted_zone = route53.HostedZone.fromHostedZoneAttributes(
      this,
      "Zone" + props.zone_apnex_name,
      { hostedZoneId: props.hosted_zone_id, zoneName: props.zone_apnex_name }
    );

    // Alias Record
    new route53.ARecord(this, "CfAliasRecord", {
      zone: hosted_zone,
      recordName: props.cfFqdn,
      target: route53.RecordTarget.fromAlias(
        new route53_targets.CloudFrontTarget(ditribution)
      ),
    });
  }
}
