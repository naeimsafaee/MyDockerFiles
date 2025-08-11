// mqttClientManager.cjs (CommonJS)
const mqtt = require('mqtt');

class MqttClientManager {
    static instance;

    constructor() {
        this.client = null;
        this.connected = false;
        this.reconnectPeriod = 1000;
        this.MAX_RECONNECT = 20000;
        this.topicHandlers = {};
    }

    static getInstance() {
        if (!MqttClientManager.instance) {
            MqttClientManager.instance = new MqttClientManager();
        }
        return MqttClientManager.instance;
    }

    connect({ host, username, password }) {
        if (this.client && this.connected) return;

        this.client = mqtt.connect(host, {
            username,
            password,
            clean: true,
            reconnectPeriod: this.reconnectPeriod,
            protocol: 'ws',
        });

        this.client.on('connect', () => {
            this.connected = true;
            console.log(`✅ Connected to ${host}`);
        });

        this.client.on('reconnect', () => {
            this.reconnectPeriod = Math.min(this.reconnectPeriod + 1000, this.MAX_RECONNECT);
            if (this.client) this.client.options.reconnectPeriod = this.reconnectPeriod;
            console.log('🔁 Reconnecting...');
        });

        this.client.on('error', (err) => {
            console.error('❌ MQTT connection error:', err);
            this.connected = false;
        });
    }

    subscribe({ topic, qos = 0, onMessage, onSubscribe }) {
        if (!this.client || !this.connected) {
            console.warn('MQTT client not connected. Cannot subscribe.');
            return;
        }

        if (this.topicHandlers[topic]) return;

        this.client.subscribe(topic, { qos }, (err) => {
            if (err) {
                console.error(`❌ Failed to subscribe to ${topic}`, err);
                return;
            }
            console.log(`📡 Subscribed to ${topic}`);
            this.topicHandlers[topic] = onMessage;
            onSubscribe && onSubscribe();
        });

        if (!this.client.listeners('message').length) {
            this.client.on('message', (incomingTopic, payload) => {
                const handler = this.topicHandlers[incomingTopic];
                if (!handler) return;

                try {
                    const parsed = JSON.parse(payload.toString());
                    handler(parsed);
                } catch (e) {
                    console.error('❌ Failed to parse MQTT message', e);
                }
            });
        }
    }

    unsubscribe(topic) {
        return new Promise((resolve, reject) => {
            if (this.client && this.topicHandlers[topic]) {
                this.client.unsubscribe(topic, (err) => {
                    if (err) {
                        console.error(`❌ Failed to unsubscribe from ${topic}`, err);
                        reject(err);
                    } else {
                        console.log(`🚫 Unsubscribed from ${topic}`);
                        delete this.topicHandlers[topic];
                        resolve();
                    }
                });
            } else {
                resolve();
            }
        });
    }

    async disconnect() {
        if (!this.client) return;

        const unsubscribePromises = Object.keys(this.topicHandlers).map((topic) =>
            this.unsubscribe(topic)
        );

        try {
            await Promise.all(unsubscribePromises);
        } catch (e) {
            console.warn('⚠️ Some subscriptions failed during disconnect.', e);
        }

        this.client.end(true, {}, () => {
            console.log('🔌 Disconnected from MQTT broker');
            this.client = null;
            this.connected = false;
        });
    }
}

MqttClientManager.getInstance().connect({
    host: "ws://storage.runflare.run:30989/mqtt",
    username: 'ClientMan',
    password: 'Client123456',
});
