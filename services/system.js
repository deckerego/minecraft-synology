const System = require('../models/system.js');
const ecsRepository = require('../repositories/ecs.js');
const elbRepository = require('../repositories/elb.js');

class SystemService {
  async getSystems(clusterName) {
    const serviceData = await ecsRepository.describeServices(clusterName);
    return await serviceData.services.reduce(async(systems, service) => {
      const loadBalancerData = await elbRepository.describeLoadBalancer(service.loadBalancers[0].targetGroupArn);

      systems.push(new System({
        name: service.serviceName,
        hostname: loadBalancerData.LoadBalancers[0].DNSName,
        port: loadBalancerData.Listeners[0].Port
      }));
      return systems;
    }, []);
  }
}

module.exports = new SystemService();
