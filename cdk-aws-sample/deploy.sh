#!/bin/bash

# Install CDK dependencies
npm install

# Build CDK TypeScript code
npm run build

# Deploy the EC2InfoStack stack
cdk bootstrap
cdk deploy EC2InfoStack
cdk deploy surecloud-cdk-scenario-prerequisite-stack
