class ApiEndpoints {
  static const String baseUrl = 'https://api.sealswp391.xyz/';
  static const String login = '/api/Auth/login';
  static const String googleLogin = '/api/Auth/google-login';
  static const String register = '/api/Auth/register';
  static const String events = '/api/Events';

  static const String refreshToken = '/api/Auth/refresh-token';
  static const String uploadFile = '/api/Storage/upload';
  static const String eventRoles = '/api/EventRoles';
  static const String userEventRoles = '/api/EventRoles/user';
  static const String userRoleInEvent = '/api/EventRoles/user-role';
  static const String eventRoleInvitations = '/api/EventRoles/invitations';
  static const String tracks = '/api/Tracks';
  static const String profile = '/api/Users/profile';
  static const String scores = '/api/Scores';
  static const String teamScoreBreakdown = '/api/Scores/team';
  static const String eventRoleScores = '/api/Scores/event-role';
  static const String finalResults = '/api/FinalResults';
  static const String teams = '/api/Teams';
}
