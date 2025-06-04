class CronUtil {
  static String cronToHuman(String cron) {
    // Helper to convert integer to ordinal string (1 → "1st", 2 → "2nd", 3 → "3rd", etc.)
    String ordinal(int day) {
      if (day % 100 >= 11 && day % 100 <= 13) {
        return '${day}th';
      }
      switch (day % 10) {
        case 1:
          return '${day}st';
        case 2:
          return '${day}nd';
        case 3:
          return '${day}rd';
        default:
          return '${day}th';
      }
    }

    // Helper to convert 24-hour time to 12-hour with AM/PM
    String formatTime(int hour, int minute) {
      final suffix = hour < 12 ? 'AM' : 'PM';
      final h12 = (hour % 12 == 0) ? 12 : hour % 12;
      final minPadded = minute.toString().padLeft(2, '0');
      return '$h12:$minPadded $suffix';
    }

    // Map 0–6 → Sunday–Saturday
    const List<String> weekdayNames = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];

    final parts = cron.trim().split(RegExp(r'\s+'));
    if (parts.length != 5) {
      return 'Unsupported cron format';
    }

    final minuteField = parts[0];
    final hourField = parts[1];
    final dayOfMonthField = parts[2];
    final monthField = parts[3];
    final dayOfWeekField = parts[4];

    // We only support "*" for the month field in this function.
    if (monthField != '*') {
      return 'Unsupported cron format';
    }

    // Try parsing minute and hour as integers.
    final minute = int.tryParse(minuteField);
    final hour = int.tryParse(hourField);
    if (minute == null ||
        minute < 0 ||
        minute > 59 ||
        hour == null ||
        hour < 0 ||
        hour > 23) {
      return 'Unsupported cron format';
    }
    final timeString = formatTime(hour, minute);

    final isDayOfMonthWildcard = (dayOfMonthField == '*');
    final isDayOfWeekWildcard = (dayOfWeekField == '*');

    // 1) Monthly: minute hour dayOfMonth * *
    if (!isDayOfMonthWildcard && isDayOfWeekWildcard) {
      final dayOfMonth = int.tryParse(dayOfMonthField);
      if (dayOfMonth == null || dayOfMonth < 1 || dayOfMonth > 31) {
        return 'Unsupported cron format';
      }
      final ordinalDay = ordinal(dayOfMonth);
      return '$timeString of every $ordinalDay day of month';
    }

    // 2) Weekly: minute hour * * dayOfWeek
    if (isDayOfMonthWildcard && !isDayOfWeekWildcard) {
      final dow = int.tryParse(dayOfWeekField);
      if (dow == null || dow < 0 || dow > 6) {
        return 'Unsupported cron format';
      }
      final weekdayName = weekdayNames[dow];
      return '$timeString of every $weekdayName';
    }

    // 3) Daily: minute hour * * *
    if (isDayOfMonthWildcard && isDayOfWeekWildcard) {
      return '$timeString every day';
    }

    // All other combinations (e.g., both dayOfMonth and dayOfWeek are specified,
    // or unsupported patterns) are not handled here.
    return 'Unsupported cron format';
  }
}
