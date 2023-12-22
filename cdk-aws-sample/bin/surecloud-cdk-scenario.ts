#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { EC2InfoStack } from '../lib/ec2-info-stack';
import { SurecloudCdkScenarioPrerequisiteStack } from '../lib/surecloud-cdk-scenario-prerequisite-stack';

const app = new cdk.App();

// Define and deploy EC2InfoStack
new EC2InfoStack(app, 'EC2InfoStack');

// Define and deploy SurecloudCdkScenarioPrerequisiteStack
new SurecloudCdkScenarioPrerequisiteStack(app, 'surecloud-cdk-scenario-prerequisite-stack');
