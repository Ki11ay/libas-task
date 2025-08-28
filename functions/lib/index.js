"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendCategoryNotification = exports.sendPromotionalNotification = exports.onOrderUpdated = exports.onOrderCreated = exports.onUserLogin = exports.onUserCreated = exports.sendPushNotificationToTopic = exports.sendPushNotificationToUser = void 0;
const https_1 = require("firebase-functions/v2/https");
const firestore_1 = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();
const messaging = admin.messaging();
// Send push notification to specific user
exports.sendPushNotificationToUser = (0, https_1.onCall)(async (request) => {
    try {
        // Check if user is authenticated
        if (!request.auth) {
            throw new Error('User must be authenticated');
        }
        const { userId, title, body, payload, data: notificationData, type } = request.data;
        // Validate required fields
        if (!userId || !title || !body) {
            throw new Error('Missing required fields');
        }
        // Get user's FCM token from Firestore
        const userDoc = await db.collection('users').doc(userId).get();
        if (!userDoc.exists) {
            throw new Error('User not found');
        }
        const userData = userDoc.data();
        const fcmToken = userData === null || userData === void 0 ? void 0 : userData.fcmToken;
        if (!fcmToken) {
            throw new Error('User has no FCM token');
        }
        // Create notification message
        const message = {
            token: fcmToken,
            notification: {
                title,
                body,
            },
            data: Object.assign({ payload: payload || '', type: type || 'general' }, notificationData),
            android: {
                notification: {
                    channelId: 'default_channel',
                    priority: 'high',
                    defaultSound: true,
                },
            },
            apns: {
                payload: {
                    aps: {
                        sound: 'default',
                        badge: 1,
                    },
                },
            },
        };
        // Send the message
        const response = await messaging.send(message);
        // Save notification to Firestore for history
        await db.collection('notifications').add({
            userId,
            title,
            body,
            payload,
            data: notificationData,
            type,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            isRead: false,
            fcmResponse: response,
        });
        return { success: true, messageId: response };
    }
    catch (error) {
        console.error('Error sending push notification:', error);
        throw new Error('Failed to send notification');
    }
});
// Send push notification to topic
exports.sendPushNotificationToTopic = (0, https_1.onCall)(async (request) => {
    try {
        // Check if user is authenticated
        if (!request.auth) {
            throw new Error('User must be authenticated');
        }
        const { topic, title, body, payload, data: notificationData, type } = request.data;
        // Validate required fields
        if (!topic || !title || !body) {
            throw new Error('Missing required fields');
        }
        // Create notification message
        const message = {
            topic,
            notification: {
                title,
                body,
            },
            data: Object.assign({ payload: payload || '', type: type || 'general' }, notificationData),
            android: {
                notification: {
                    channelId: 'default_channel',
                    priority: 'high',
                    defaultSound: true,
                },
            },
            apns: {
                payload: {
                    aps: {
                        sound: 'default',
                        badge: 1,
                    },
                },
            },
        };
        // Send the message
        const response = await messaging.send(message);
        // Save notification to Firestore for history (for all users subscribed to topic)
        await db.collection('topic_notifications').add({
            topic,
            title,
            body,
            payload,
            data: notificationData,
            type,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            fcmResponse: response,
        });
        return { success: true, messageId: response };
    }
    catch (error) {
        console.error('Error sending topic notification:', error);
        throw new Error('Failed to send topic notification');
    }
});
// Send welcome notification when user signs up
exports.onUserCreated = (0, firestore_1.onDocumentCreated)('users/{userId}', async (event) => {
    var _a, _b;
    try {
        const userData = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
        const userId = event.params.userId;
        const userName = (userData === null || userData === void 0 ? void 0 : userData.displayName) || 'there';
        // Get user's FCM token from Firestore
        const userDoc = await db.collection('users').doc(userId).get();
        if (!userDoc.exists)
            return;
        const fcmToken = (_b = userDoc.data()) === null || _b === void 0 ? void 0 : _b.fcmToken;
        if (!fcmToken)
            return;
        // Create and send welcome notification directly
        const message = {
            token: fcmToken,
            notification: {
                title: 'Welcome to Libas! 🎉',
                body: `Hi ${userName}! We're excited to have you on board. Start exploring our amazing products!`,
            },
            data: {
                payload: 'welcome',
                type: 'welcome',
                userName,
                action: 'welcome',
            },
            android: {
                notification: {
                    channelId: 'default_channel',
                    priority: 'high',
                    defaultSound: true,
                },
            },
            apns: {
                payload: {
                    aps: {
                        sound: 'default',
                        badge: 1,
                    },
                },
            },
        };
        await messaging.send(message);
        // Subscribe user to general topics
        await messaging.subscribeToTopic([fcmToken], 'all_users');
        await messaging.subscribeToTopic([fcmToken], 'new_users');
        console.log(`Welcome notification sent to user ${userId}`);
    }
    catch (error) {
        console.error('Error in onUserCreated:', error);
    }
});
// Send welcome back notification when user logs in
exports.onUserLogin = (0, https_1.onCall)(async (request) => {
    var _a;
    try {
        if (!request.auth) {
            throw new Error('User must be authenticated');
        }
        const userId = request.auth.uid;
        const { userName } = request.data;
        // Create and send welcome back notification directly
        const userDoc = await db.collection('users').doc(userId).get();
        if (!userDoc.exists) {
            throw new Error('User not found');
        }
        const fcmToken = (_a = userDoc.data()) === null || _a === void 0 ? void 0 : _a.fcmToken;
        if (!fcmToken) {
            throw new Error('User has no FCM token');
        }
        const message = {
            token: fcmToken,
            notification: {
                title: 'Welcome back! 👋',
                body: `Hi ${userName || 'there'}! We missed you. Check out our latest arrivals and exclusive offers!`,
            },
            data: {
                payload: 'welcome_back',
                type: 'welcome_back',
                userName: userName || 'there',
                action: 'welcome_back',
            },
            android: {
                notification: {
                    channelId: 'default_channel',
                    priority: 'high',
                    defaultSound: true,
                },
            },
            apns: {
                payload: {
                    aps: {
                        sound: 'default',
                        badge: 1,
                    },
                },
            },
        };
        await messaging.send(message);
        return { success: true };
    }
    catch (error) {
        console.error('Error in onUserLogin:', error);
        throw new Error('Failed to send welcome back notification');
    }
});
// Send order confirmation notification
exports.onOrderCreated = (0, firestore_1.onDocumentCreated)('orders/{orderId}', async (event) => {
    var _a, _b;
    try {
        const orderData = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
        const userId = orderData === null || orderData === void 0 ? void 0 : orderData.userId;
        const orderId = event.params.orderId;
        const totalAmount = (orderData === null || orderData === void 0 ? void 0 : orderData.totalAmount) || 0;
        if (!userId)
            return;
        // Get user's FCM token from Firestore
        const userDoc = await db.collection('users').doc(userId).get();
        if (!userDoc.exists)
            return;
        const fcmToken = (_b = userDoc.data()) === null || _b === void 0 ? void 0 : _b.fcmToken;
        if (!fcmToken)
            return;
        // Create and send order confirmation notification directly
        const message = {
            token: fcmToken,
            notification: {
                title: 'Order Confirmed! ✅',
                body: `Your order #${orderId} has been confirmed. Total: $${totalAmount.toFixed(2)}`,
            },
            data: {
                payload: 'purchase_complete',
                type: 'purchase_complete',
                orderId,
                totalAmount: totalAmount.toString(),
                action: 'purchase_complete',
            },
            android: {
                notification: {
                    channelId: 'default_channel',
                    priority: 'high',
                    defaultSound: true,
                },
            },
            apns: {
                payload: {
                    aps: {
                        sound: 'default',
                        badge: 1,
                    },
                },
            },
        };
        await messaging.send(message);
        console.log(`Order confirmation notification sent to user ${userId} for order ${orderId}`);
    }
    catch (error) {
        console.error('Error in onOrderCreated:', error);
    }
});
// Send shipping update notification
exports.onOrderUpdated = (0, firestore_1.onDocumentUpdated)('orders/{orderId}', async (event) => {
    var _a, _b, _c;
    try {
        const beforeData = (_a = event.data) === null || _a === void 0 ? void 0 : _a.before.data();
        const afterData = (_b = event.data) === null || _b === void 0 ? void 0 : _b.after.data();
        const orderId = event.params.orderId;
        // Check if shipping status changed
        if ((beforeData === null || beforeData === void 0 ? void 0 : beforeData.shippingStatus) !== (afterData === null || afterData === void 0 ? void 0 : afterData.shippingStatus)) {
            const userId = afterData === null || afterData === void 0 ? void 0 : afterData.userId;
            const newStatus = afterData === null || afterData === void 0 ? void 0 : afterData.shippingStatus;
            if (!userId || !newStatus)
                return;
            // Get user's FCM token from Firestore
            const userDoc = await db.collection('users').doc(userId).get();
            if (!userDoc.exists)
                return;
            const fcmToken = (_c = userDoc.data()) === null || _c === void 0 ? void 0 : _c.fcmToken;
            if (!fcmToken)
                return;
            // Create and send shipping update notification directly
            const message = {
                token: fcmToken,
                notification: {
                    title: 'Shipping Update 📦',
                    body: `Order #${orderId}: ${newStatus}`,
                },
                data: {
                    payload: 'shipping_update',
                    type: 'shipping_update',
                    orderId,
                    status: newStatus,
                    action: 'shipping_update',
                },
                android: {
                    notification: {
                        channelId: 'default_channel',
                        priority: 'high',
                        defaultSound: true,
                    },
                },
                apns: {
                    payload: {
                        aps: {
                            sound: 'default',
                            badge: 1,
                        },
                    },
                },
            };
            await messaging.send(message);
            console.log(`Shipping update notification sent to user ${userId} for order ${orderId}`);
        }
    }
    catch (error) {
        console.error('Error in onOrderUpdated:', error);
    }
});
// Send promotional notification to all users
exports.sendPromotionalNotification = (0, https_1.onCall)(async (request) => {
    try {
        // Check if user is admin (you can implement your own admin check)
        if (!request.auth) {
            throw new Error('User must be authenticated');
        }
        const { title, body, payload, notificationData } = request.data;
        if (!title || !body) {
            throw new Error('Missing required fields');
        }
        // Create and send promotional notification to all users topic
        const message = {
            topic: 'all_users',
            notification: {
                title,
                body,
            },
            data: Object.assign({ payload: payload || '', type: 'promotional' }, notificationData),
            android: {
                notification: {
                    channelId: 'default_channel',
                    priority: 'high',
                    defaultSound: true,
                },
            },
            apns: {
                payload: {
                    aps: {
                        sound: 'default',
                        badge: 1,
                    },
                },
            },
        };
        await messaging.send(message);
        return { success: true };
    }
    catch (error) {
        console.error('Error sending promotional notification:', error);
        throw new Error('Failed to send promotional notification');
    }
});
// Send category-specific notification
exports.sendCategoryNotification = (0, https_1.onCall)(async (request) => {
    try {
        if (!request.auth) {
            throw new Error('User must be authenticated');
        }
        const { category, title, body, payload, notificationData } = request.data;
        if (!category || !title || !body) {
            throw new Error('Missing required fields');
        }
        // Create and send category-specific notification
        const message = {
            topic: `category_${category}`,
            notification: {
                title,
                body,
            },
            data: Object.assign({ payload: payload || '', type: 'promotional' }, notificationData),
            android: {
                notification: {
                    channelId: 'default_channel',
                    priority: 'high',
                    defaultSound: true,
                },
            },
            apns: {
                payload: {
                    aps: {
                        sound: 'default',
                        badge: 1,
                    },
                },
            },
        };
        await messaging.send(message);
        return { success: true };
    }
    catch (error) {
        console.error('Error sending category notification:', error);
        throw new Error('Failed to send category notification');
    }
});
//# sourceMappingURL=index.js.map