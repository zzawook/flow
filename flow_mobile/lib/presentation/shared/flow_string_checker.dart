class FlowStringChecker {
  static bool isValidEmail(String email) {
    // Simple regex for email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static String isValidPassword(String password) {
    // Password must be at least 8 characters long and contain a mix of letters and numbers and special characters
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    if (!hasLetter) return 'Password must include at least one letter';
    if (!hasNumber) return 'Password must include at least one number';
    if (!hasSpecialChar) {
      return 'Password must include at least one special character';
    }
    return '';
  }
}
