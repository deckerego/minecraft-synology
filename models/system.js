class System {
  constructor({
    name,
    hostname,
    port
  } = {}) {
    this.name = name;
    this.hostname = hostname;
    this.port = port
  }
}

module.exports = System;
