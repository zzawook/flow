class DateTimeUtil {
  static String getFormattedDate(DateTime dateTime) {
    return '${dateTime.day} ${getMonthName(dateTime.month).substring(0, 3)} ${dateTime.year}';
  }

  static int daysInMonth(int year, int month) {
    // If month=12, month+1=13 => next year january => day=0 => last day of the previous month
    final lastDay = DateTime(year, month + 1, 0);
    return lastDay.day;
  }

  static DateTime parseDate(String dateString) {
    final dateParts = dateString.split('/');
    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = int.parse(dateParts[2]);
    return DateTime(year, month, day);
  }

  static DateTime parseDateYYYYMMDDWithDash(String dateString) {
    final dateParts = dateString.split('-');
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);
    return DateTime(year, month, day);
  }

  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  static String getDatePostFix(int dat) {
    if (dat == 1 || dat == 21) {
      return 'st';
    } else if (dat == 2 || dat == 22) {
      return 'nd';
    } else if (dat == 3 || dat == 23) {
      return 'rd';
    } else {
      return 'th';
    }
  }

  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
