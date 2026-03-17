enum NotificationMethod { email, sms }

NotificationMethod notificationFromString(String value) {
  switch (value) {
    case 'email':
      return NotificationMethod.email;
    case 'sms':
      return NotificationMethod.sms;
    default:
      throw ArgumentError('Invalid notification method: $value');
  }
}
