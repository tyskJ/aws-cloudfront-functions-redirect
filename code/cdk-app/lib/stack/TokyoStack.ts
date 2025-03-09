import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";
import { Parameter } from "../../parameter";
import * as acm from "aws-cdk-lib/aws-certificatemanager";

export interface TokyoStackProps extends Parameter {
  cfCert: acm.Certificate;
}

export class TokyoStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: TokyoStackProps) {
    super(scope, id, props);
  }
}
