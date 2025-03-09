#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import { VirginiaStack } from "../lib/stack/VirginiaStack";
import { TokyoStack } from "../lib/stack/TokyoStack";
import { devParameter } from "../parameter";

const app = new cdk.App();

// Certificate for CloudFront
const virginia = new VirginiaStack(app, "VirginiaStack", {
  env: {
    region: "us-east-1",
  },
  crossRegionReferences: true,
  description: "Virginia Region Stack.",
});
cdk.Tags.of(virginia).add("Env", "Virginia");

// Tokyo Stack
const tokyo = new TokyoStack(app, "TokyoStack", {
  crossRegionReferences: true,
  ...devParameter,
  cfCert: virginia.CfCertificate,
  description: "Tokyo Region Stack.",
});
cdk.Tags.of(tokyo).add("Env", devParameter.EnvName);
