import * as cdk from 'aws-cdk-lib';
import {Template} from 'aws-cdk-lib/assertions';
import {SurecloudCdkScenarioPrerequisiteStack} from "../lib/surecloud-cdk-scenario-prerequisite-stack";

test('Stack should have 3 instances', () => {
    const app = new cdk.App();
    const stack = new SurecloudCdkScenarioPrerequisiteStack(app, 'test-stack');

    const template = Template.fromStack(stack);

    template.resourceCountIs('AWS::EC2::Instance', 3);
});

test('Stack should have EC2 instance called DevInstance and tagged with department', () => {
    const app = new cdk.App();
    const stack = new SurecloudCdkScenarioPrerequisiteStack(app, 'test-stack');

    const template = Template.fromStack(stack);

    template.hasResourceProperties('AWS::EC2::Instance', {
        Tags: [{Key: 'department', Value: 'development'},
            {Key: 'Name', Value: 'DevInstance'}]
    });
})

test('Stack should have EC2 instance called FinanceInstance and tagged with department', () => {
    const app = new cdk.App();
    const stack = new SurecloudCdkScenarioPrerequisiteStack(app, 'test-stack');

    const template = Template.fromStack(stack);

    template.hasResourceProperties('AWS::EC2::Instance', {
        Tags: [{Key: 'department', Value: 'finance'},
            {Key: 'Name', Value: 'FinanceInstance'}]
    });
})

test('Stack should have EC2 instance called AutomatedTestingInstance and tagged with department', () => {
    const app = new cdk.App();
    const stack = new SurecloudCdkScenarioPrerequisiteStack(app, 'test-stack');

    const template = Template.fromStack(stack);

    template.hasResourceProperties('AWS::EC2::Instance', {
        Tags: [{Key: 'department', Value: 'development'},
            {Key: 'Name', Value: 'AutomatedTestingInstance'}]
    });
})
