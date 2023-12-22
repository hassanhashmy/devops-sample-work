import {Stack, StackProps, Tags} from 'aws-cdk-lib';
import {Construct} from 'constructs';
import {AmazonLinuxImage, Instance, InstanceClass, InstanceSize, InstanceType, Vpc} from "aws-cdk-lib/aws-ec2";

export class SurecloudCdkScenarioPrerequisiteStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const vpc = new Vpc(this, 'surecloud-vpc');

    const anEc2Instance = new Instance(this, 'an-ec2-instance', {
      instanceType: InstanceType.of(InstanceClass.T2, InstanceSize.MICRO),
      machineImage: new AmazonLinuxImage(),
      vpc: vpc,
      instanceName: 'DevInstance'
    });
    Tags.of(anEc2Instance).add('department', 'development');

    const anotherEc2Instance = new Instance(this, 'another-ec2-instance', {
      instanceType: InstanceType.of(InstanceClass.T2, InstanceSize.MICRO),
      machineImage: new AmazonLinuxImage(),
      vpc: vpc,
      instanceName: 'FinanceInstance'
    });
    Tags.of(anotherEc2Instance).add('department', 'finance');

    const yetAnotherEc2Instance = new Instance(this, 'yet-another-ec2-instance', {
      instanceType: InstanceType.of(InstanceClass.T2, InstanceSize.MICRO),
      machineImage: new AmazonLinuxImage(),
      vpc: vpc,
      instanceName: 'AutomatedTestingInstance'
    });
    Tags.of(yetAnotherEc2Instance).add('department', 'development');

  }
}
