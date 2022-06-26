const systemService = require('../services/system.js');
const clusterName = process.env.CLUSTER_NAME || 'local';

module.exports.handler = async (event) => {
  const systems = await systemService.getSystems(clusterName);

  return {
    statusCode: 200,
    body: JSON.stringify(systems, null, 2)
  };
};
