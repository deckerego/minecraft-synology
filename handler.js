'use strict';

module.exports.status = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: 'minecraft-ecs supposedly online',
        input: event,
      },
      null,
      2
    ),
  };
};
