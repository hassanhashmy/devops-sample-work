# SureCloud AWS CDK 

SureCloud has 3 EC2 instances which are assigned to different parts of the business. We need to know which instances
belong to which areas of the business so that specific actions can be performed.

## Instructions

* Please create a free AWS account if you don't already have one. You will need one to deploy and test your attempt.
* Please fork this and submit your solution via GitHub or GitLab.
* This scenario is designed to take no longer than an hour.
* Note you may need to bootstrap your environment (make sure you destroy bootstrap stack after submission to avoid
  incurring possible costs).

## Objectives

* Create a new stack, with a lambda which returns the names and tags of the EC2 instances.
* Add test coverage for any code you do write.
* Add script/s to deploy your stack and document them below.

## Criteria

* All the dependencies that are needed for a successful implementation are already in the project, so there is no need
  to add anymore.
* The lambda itself can be written in any supported language but the supporting infrastructure should be written in
  Typescript
* Do not edit `surecloud-cdk-scenario-prerequisite-stack.ts`

## Useful commands

* `npm install`     installs the dependencies required for the app
* `npm run build`   compile typescript to js
* `npm run watch`   watch for changes and compile
* `npm run test`    perform the jest unit tests
* `cdk deploy surecloud-cdk-scenario-prerequisite-stack` deploy prerequisite stack to your default AWS account/region
* `cdk diff`        compare deployed stacks with current state
* `cdk synth`       emits the synthesized CloudFormation template
* `cdk destroy surecloud-cdk-scenario-prerequisite-stack` destroys prerequisite stack from your default AWS
  account/region

