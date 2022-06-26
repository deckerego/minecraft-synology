/** https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/clients/client-ecs/index.html **/
const { ECSClient, ListServicesCommand, DescribeServicesCommand } = require("@aws-sdk/client-ecs");
const AWS_REGION = process.env.AWS_REGION || 'localhost';

class ECSRepository {
  constructor() {
    this.ecsClient = new ECSClient({ region: AWS_REGION });
  }

  async describeServices(clusterArn) {
    const listParams = {
      cluster: clusterArn
    };
    const listCommand = new ListServicesCommand(listParams);
    const listData = await this.ecsClient.send(listCommand);

    const describeParams = {
      cluster: clusterArn,
      services: listData.serviceArns
    }
    const describeCommand = new DescribeServicesCommand(describeParams);
    const describeData = await this.ecsClient.send(describeCommand);
    return {
      services: describeData.services
    };
  }
}

module.exports = new ECSRepository();
