// ec2-info-stack.ts
import * as cdk from 'aws-cdk-lib';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as apigateway from 'aws-cdk-lib/aws-apigateway';
import * as iam from 'aws-cdk-lib/aws-iam';
import { Duration } from 'aws-cdk-lib';
import { Construct } from 'constructs';

export class EC2InfoStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Lambda function
    const ec2InfoLambda = new lambda.Function(this, 'EC2InfoLambda', {
      runtime: lambda.Runtime.NODEJS_14_X, // Use Node.js 18
      handler: 'lambda/handler.handler',
      code: lambda.Code.fromAsset('lambda'), // Assuming your Lambda code is in a 'lambda' directory
      timeout: Duration.seconds(10),
      memorySize: 256,
      environment: {},
    });

    // Grant necessary permissions to Lambda function
    ec2InfoLambda.addToRolePolicy(new iam.PolicyStatement({
      actions: ['ec2:DescribeInstances'],
      resources: ['*'], // Be more restrictive in a production environment
    }));

    // API Gateway
    const api = new apigateway.RestApi(this, 'EC2InfoApi', {
      restApiName: 'EC2 Info API',
      description: 'API to get EC2 instance names and tags',
    });

    const integration = new apigateway.LambdaIntegration(ec2InfoLambda);
    api.root.addMethod('GET', integration);

    // Output the API endpoint URL
    new cdk.CfnOutput(this, 'EC2InfoApiUrl', {
      value: api.url,
    });
  }
}
