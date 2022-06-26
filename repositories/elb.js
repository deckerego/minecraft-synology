/** https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/clients/client-elastic-load-balancing-v2/index.html **/
const { ElasticLoadBalancingV2Client, DescribeTargetGroupsCommand, DescribeLoadBalancersCommand, DescribeListenersCommand } = require("@aws-sdk/client-elastic-load-balancing-v2");
const AWS_REGION = process.env.AWS_REGION || 'localhost';

class ELBRepository {
  constructor() {
    this.elbClient = new ElasticLoadBalancingV2Client({ region: AWS_REGION });
  }

  async describeLoadBalancer(targetGroupArn) {
    const describeTargetGroupParams = {
      TargetGroupArns: [ targetGroupArn ]
    }
    const describeTargetGroupCommand = new DescribeTargetGroupsCommand(describeTargetGroupParams);
    const describeTargetGroupData = await this.elbClient.send(describeTargetGroupCommand);

    const describeLoadBalancerParams = {
      LoadBalancerArns: [ describeTargetGroupData.TargetGroups[0].LoadBalancerArns[0] ]
    }
    const describeLoadBalancerCommand = new DescribeLoadBalancersCommand(describeLoadBalancerParams);

    const describeListenerParams = {
      LoadBalancerArn: [ describeTargetGroupData.TargetGroups[0].LoadBalancerArns[0] ]
    }
    const describeListenerCommand = new DescribeListenersCommand(describeListenerParams);

    const loadBalancerData = await Promise.all([
      this.elbClient.send(describeLoadBalancerCommand),
      this.elbClient.send(describeListenerCommand)
    ]);

    return {
      LoadBalancers: loadBalancerData[0].LoadBalancers,
      Listeners: loadBalancerData[1].Listeners
    };
  }
}

module.exports = new ELBRepository();
