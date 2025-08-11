const mqtt = require('mqtt');

// Connection options
const options = {
    port: '31656',
    host: 'storage.runflare.run',//178.239.147.37:30989
    protocol: 'mqtt',
    username: 'GeneralMan',
    password: 'nMi-ey@SG!p7zgc'
};

const client = mqtt.connect(options);

client.on('connect', () => {
    console.log('✅ Connected to MQTT broker');
});

client.on('error', (err) => {
    console.log(`❌ MQTT connection error: ${err.message}`);
});

function publish(topic, message) {
    client.publish(topic, JSON.stringify(message));
}

module.exports = { publish };