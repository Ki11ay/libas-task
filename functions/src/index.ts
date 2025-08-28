import { onCall } from 'firebase-functions/v2/https';
import { onDocumentCreated, onDocumentUpdated } from 'firebase-functions/v2/firestore';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

// Send push notification to specific user
export const sendPushNotificationToUser = onCall(async (request) => {
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
    const fcmToken = userData?.fcmToken;

    if (!fcmToken) {
      throw new Error('User has no FCM token');
    }

    // Create notification message
    const message: admin.messaging.Message = {
      token: fcmToken,
      notification: {
        title,
        body,
      },
      data: {
        payload: payload || '',
        type: type || 'general',
        ...notificationData,
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
  } catch (error) {
    console.error('Error sending push notification:', error);
    throw new Error('Failed to send notification');
  }
});

// Send push notification to topic
export const sendPushNotificationToTopic = onCall(async (request) => {
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
    const message: admin.messaging.Message = {
      topic,
      notification: {
        title,
        body,
      },
      data: {
        payload: payload || '',
        type: type || 'general',
        ...notificationData,
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
  } catch (error) {
    console.error('Error sending topic notification:', error);
    throw new Error('Failed to send topic notification');
  }
});

// Send welcome notification when user signs up
export const onUserCreated = onDocumentCreated('users/{userId}', async (event) => {
    try {
      const userData = event.data?.data();
      const userId = event.params.userId;
      const userName = userData?.displayName || 'there';

      // Get user's FCM token from Firestore
      const userDoc = await db.collection('users').doc(userId).get();
      if (!userDoc.exists) return;

      const fcmToken = userDoc.data()?.fcmToken;
      if (!fcmToken) return;

      // Create and send welcome notification directly
      const message: admin.messaging.Message = {
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

    } catch (error) {
      console.error('Error in onUserCreated:', error);
    }
  });

// Send welcome back notification when user logs in
export const onUserLogin = onCall(async (request) => {
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

    const fcmToken = userDoc.data()?.fcmToken;
    if (!fcmToken) {
      throw new Error('User has no FCM token');
    }

    const message: admin.messaging.Message = {
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
  } catch (error) {
    console.error('Error in onUserLogin:', error);
    throw new Error('Failed to send welcome back notification');
  }
});

// Send order confirmation notification
export const onOrderCreated = onDocumentCreated('orders/{orderId}', async (event) => {
    try {
      const orderData = event.data?.data();
      const userId = orderData?.userId;
      const orderId = event.params.orderId;
      const totalAmount = orderData?.totalAmount || 0;

      if (!userId) return;

      // Get user's FCM token from Firestore
      const userDoc = await db.collection('users').doc(userId).get();
      if (!userDoc.exists) return;

      const fcmToken = userDoc.data()?.fcmToken;
      if (!fcmToken) return;

      // Create and send order confirmation notification directly
      const message: admin.messaging.Message = {
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

    } catch (error) {
      console.error('Error in onOrderCreated:', error);
    }
  });

// Send shipping update notification
export const onOrderUpdated = onDocumentUpdated('orders/{orderId}', async (event) => {
    try {
      const beforeData = event.data?.before.data();
      const afterData = event.data?.after.data();
      const orderId = event.params.orderId;

      // Check if shipping status changed
      if (beforeData?.shippingStatus !== afterData?.shippingStatus) {
        const userId = afterData?.userId;
        const newStatus = afterData?.shippingStatus;

        if (!userId || !newStatus) return;

        // Get user's FCM token from Firestore
        const userDoc = await db.collection('users').doc(userId).get();
        if (!userDoc.exists) return;

        const fcmToken = userDoc.data()?.fcmToken;
        if (!fcmToken) return;

        // Create and send shipping update notification directly
        const message: admin.messaging.Message = {
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
    } catch (error) {
      console.error('Error in onOrderUpdated:', error);
    }
  });

// Send promotional notification to all users
export const sendPromotionalNotification = onCall(async (request) => {
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
    const message: admin.messaging.Message = {
      topic: 'all_users',
      notification: {
        title,
        body,
      },
      data: {
        payload: payload || '',
        type: 'promotional',
        ...notificationData,
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
  } catch (error) {
    console.error('Error sending promotional notification:', error);
    throw new Error('Failed to send promotional notification');
  }
});

// Send category-specific notification
export const sendCategoryNotification = onCall(async (request) => {
  try {
    if (!request.auth) {
      throw new Error('User must be authenticated');
    }

    const { category, title, body, payload, notificationData } = request.data;

    if (!category || !title || !body) {
      throw new Error('Missing required fields');
    }

    // Create and send category-specific notification
    const message: admin.messaging.Message = {
      topic: `category_${category}`,
      notification: {
        title,
        body,
      },
      data: {
        payload: payload || '',
        type: 'promotional',
        ...notificationData,
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
  } catch (error) {
    console.error('Error sending category notification:', error);
    throw new Error('Failed to send category notification');
  }
});
