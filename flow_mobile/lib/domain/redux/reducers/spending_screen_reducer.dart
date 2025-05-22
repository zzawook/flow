import 'package:flow_mobile/domain/redux/actions/spending_screen_actions.dart';
import 'package:flow_mobile/domain/redux/states/spending_screen_state.dart';

SpendingScreenState spendingScreenReducer(
  SpendingScreenState state,
  dynamic action,
) {
  if (action is DecrementDisplayedMonthAction) {
    DateTime modifiedDisplayedMonth = decrementMonth(state.displayedMonth);

    DateTime modifiedWeeklyCalendarDisplayWeek = DateTime(
      modifiedDisplayedMonth.year,
      modifiedDisplayedMonth.month,
      // modifiedDIsplayedMonth's last day of the month
      1
    );

    // modifiedWeeklyCalendarDisplayWeek's week's monday
    DateTime selectedDate = modifiedWeeklyCalendarDisplayWeek.subtract(
      Duration(
        days: modifiedWeeklyCalendarDisplayWeek.weekday - DateTime.monday,
      ),
    );

    return state.copyWith(
      displayedMonth: modifiedDisplayedMonth,
      weeklySpendingCalendarDisplayWeek: selectedDate,
      selectedDate: selectedDate,
    );
  } else if (action is IncrementDisplayedMonthAction) {
    if (state.displayedMonth.month == DateTime.now().month &&
        state.displayedMonth.year == DateTime.now().year) {
      DateTime thisWeekMonday = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).subtract(Duration(days: DateTime.now().weekday - 1));
      return state.copyWith(
        weeklySpendingCalendarDisplayWeek: thisWeekMonday,
        selectedDate: thisWeekMonday,
      );
    }
    DateTime modifiedDisplayedMonth = incrementMonth(state.displayedMonth);

    DateTime modifiedWeeklyCalendarDisplayWeek = DateTime(
      modifiedDisplayedMonth.year,
      modifiedDisplayedMonth.month,
      1,
    );

    DateTime selectedDate = modifiedWeeklyCalendarDisplayWeek;

    return state.copyWith(
      displayedMonth: modifiedDisplayedMonth,
      weeklySpendingCalendarDisplayWeek: selectedDate,
      selectedDate: selectedDate,
    );
  } else if (action is SetDisplayedMonthAction) {
    DateTime newDisplayedMonth = action.displayMonthYear;
    // Check if newDisplayedMonth is in the same month as the displayed month
    if (isSameMonth(newDisplayedMonth, state.displayedMonth)) {
      return state.copyWith(displayedMonth: newDisplayedMonth);
    } else {
      // If not, set the displayed month to the month of newDisplayedMonth
      DateTime newWeeklySpendingCalendarDisplayWeek = DateTime(
        newDisplayedMonth.year,
        newDisplayedMonth.month,
      );
      return state.copyWith(
        displayedMonth: DateTime(
          newDisplayedMonth.year,
          newDisplayedMonth.month,
        ),
        weeklySpendingCalendarDisplayWeek: newWeeklySpendingCalendarDisplayWeek,
        selectedDate: newWeeklySpendingCalendarDisplayWeek,
      );
    }
  } else if (action is SetWeeklySpendingCalendarDisplayWeekAction) {
    DateTime newWeekStart = action.weeklySpendingCalendarDisplayWeek;
    // Check if newWeekStart is a Monday
    if (newWeekStart.weekday != DateTime.monday) {
      // If not, adjust to the this Monday
      newWeekStart = newWeekStart.subtract(
        Duration(days: newWeekStart.weekday - DateTime.monday),
      );
    }

    DateTime newWeekEnd = newWeekStart.add(Duration(days: 6));

    // Check if the week containing newWeekStart contains some day in the displayedMonth
    if (newWeekStart.month == state.displayedMonth.month ||
        newWeekEnd.month == state.displayedMonth.month) {
      DateTime revisedSelectedDate;
      if (isSameMonth(newWeekStart, state.displayedMonth)) {
        revisedSelectedDate = newWeekStart;
      } else if (isSameMonth(newWeekEnd, state.displayedMonth)) {
        revisedSelectedDate = DateTime(newWeekEnd.year, newWeekEnd.month, 1);
      } else {
        revisedSelectedDate = DateTime(
          newWeekStart.year,
          newWeekStart.month,
          newWeekStart.day,
        );
      }
      return state.copyWith(
        weeklySpendingCalendarDisplayWeek: newWeekStart,
        selectedDate: revisedSelectedDate,
      );
    } else {
      return state.copyWith(
        displayedMonth: DateTime(newWeekStart.year, newWeekStart.month),
        weeklySpendingCalendarDisplayWeek: newWeekStart,
        selectedDate: newWeekStart,
      );
    }
  } else if (action is SetSelectedDateAction) {
    if (action.selectedDate.month != state.displayedMonth.month) {
      // If the selected date is not in the displayed month, set the displayed month to the selected date's month
      DateTime newDisplayedMonth = DateTime(
        action.selectedDate.year,
        action.selectedDate.month,
      );
      return state.copyWith(
        displayedMonth: newDisplayedMonth,
        selectedDate: action.selectedDate,
      );
    }
    return state.copyWith(selectedDate: action.selectedDate);
  } else if (action is SetCalendarSelectedDateAction) {
    return state.copyWith(calendarSelectedDate: action.calendarSelectedDate);
  }
  return state;
}

bool isSameMonth(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month;
}

bool isJanuary(DateTime date) {
  return date.month == DateTime.january;
}

DateTime decrementMonth(DateTime date) {
  if (date.month == DateTime.january) {
    return DateTime(date.year - 1, DateTime.december);
  } else {
    return DateTime(date.year, date.month - 1);
  }
}

DateTime incrementMonth(DateTime date) {
  if (date.month == DateTime.december) {
    return DateTime(date.year + 1, DateTime.january);
  } else {
    return DateTime(date.year, date.month + 1);
  }
}
