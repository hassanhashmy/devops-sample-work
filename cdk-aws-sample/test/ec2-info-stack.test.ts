// test/ec2-info-stack.test.ts
import * as cdk from 'aws-cdk-lib';
import {Template} from 'aws-cdk-lib/assertions';
import {EC2InfoStack} from "../lib/ec2-info-stack";

test('Stack should have Lambda function and API Gateway', () => {
    const app = new cdk.App();
    const stack = new EC2InfoStack(app, 'test-stack');

    const template = Template.fromStack(stack);

    // Validate the presence of Lambda function and API Gateway
    template.resourceCountIs('AWS::Lambda::Function', 1);
    template.resourceCountIs('AWS::ApiGateway::RestApi', 1);
});

// Add more test cases as needed to validate the behavior of your stack
