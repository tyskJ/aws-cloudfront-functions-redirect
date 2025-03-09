import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";
import { Acm } from "../construct/acm";
import * as acm from "aws-cdk-lib/aws-certificatemanager";

export class VirginiaStack extends cdk.Stack {
  public readonly CfCertificate: acm.Certificate;

  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const useast1Acm = new Acm(this, "UsEast1Acm", {
      hosted_zone_id: this.node.tryGetContext("hosted_zone_id_for_cf"),
      zone_apnex_name: this.node.tryGetContext("zone_apnex_name_for_cf"),
      issue_domain_name: this.node.tryGetContext("issue_domain_name_for_cf"),
    });
    this.CfCertificate = useast1Acm.certificate;
  }
}
