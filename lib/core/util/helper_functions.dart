String agoFromDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  final days = difference.inDays;
  final hours = difference.inHours;
  final minutes = difference.inMinutes;
  final seconds = difference.inSeconds;

  if (days > 0) {
    return '$days days ago';
  } else if (hours > 0) {
    return '$hours hours ago';
  } else if (minutes > 0) {
    return '${minutes}m ago';
  } else if (seconds > 0) {
    return '${seconds}s ago';
  } else {
    return 'Just now';
  }
}
