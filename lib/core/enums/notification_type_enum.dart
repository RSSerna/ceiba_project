enum NotificationMethod { email, sms }

extension NotificationMethodExtension on NotificationMethod {
  static NotificationMethod fromString(String value) {
    switch (value) {
      case 'email':
        return NotificationMethod.email;
      case 'sms':
        return NotificationMethod.sms;
      default:
        throw ArgumentError('Invalid notification method: $value');
    }
  }
}
