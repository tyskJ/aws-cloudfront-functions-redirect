#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import { VirginiaStack } from "../lib/stack/VirginiaStack";

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
