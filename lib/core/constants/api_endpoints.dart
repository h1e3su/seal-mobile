class ApiEndpoints {
  static const String baseUrl = 'https://seal-bl3w-backend.onrender.com/';

  // 1. Auth & Account
  static const String login = '/api/Auth/login';
  static const String googleLogin = '/api/Auth/google-login';
  static const String register = '/api/Auth/register';
  static const String refreshToken = '/api/Auth/refresh-token';
  static const String forgotPassword = '/api/Auth/forgot-password';
  static const String resetPassword = '/api/Auth/reset-password';
  static const String changePassword = '/api/Auth/change-password';
  static const String logout = '/api/Auth/logout';
  static const String verifyEmail = '/api/Auth/verify-email';
  static const String studentProfiles = '/api/Auth/student-profiles';
  static const String requestUnblock = '/api/Auth/request-unblock';

  // Users & Master Data
  static const String profile = '/api/Users/profile';
  static const String myInvitations = '/api/Users/my-invitations';
  static const String userRejections = '/api/UserRejections/my-rejections';
  static const String schools = '/api/Schools';
  static const String schoolsWithCount = '/api/Schools/with-user-count';
  static const String fptMockStudent = '/api/fpt-mock/students';

  // 2. Events, Rounds & Tracks
  static const String events = '/api/Events';
  static const String upcomingEvents = '/api/Events/upcoming';
  static const String myEvents = '/api/Events/my-events';
  static const String rounds = '/api/Rounds';
  static const String roundsByEvent = '/api/Rounds/event';
  static const String tracks = '/api/Tracks';
  static const String tracksByEvent = '/api/Tracks/event';

  // 3. Event Roles
  static const String eventRoles = '/api/EventRoles';
  static const String userEventRoles = '/api/EventRoles/user';
  static const String userRoleInEvent = '/api/EventRoles/user-role';
  static const String eventRoleInvitations = '/api/EventRoles/invitations';
  static const String eventRoleTypes = '/api/EventRoles/types';

  // 4. Teams
  static const String teams = '/api/Teams';
  static const String myTeam = '/api/Teams/my-team';
  static const String teamInvitations = '/api/Teams/invitations';
  static const String mySubmissions = '/api/Teams/my-submissions';

  // 5. Submissions & Storage
  static const String submitResults = '/api/SubmitResults';
  static const String uploadFile = '/api/Storage/upload';

  // 6. Scores, Templates & Leaderboard
  static const String scores = '/api/Scores';
  static const String saveScore = '/api/Scores/save';
  static const String teamScoreBreakdown = '/api/Scores/team';
  static const String eventRoleScores = '/api/Scores/event-role';
  static const String templates = '/api/Templates';
  static const String finalResults = '/api/FinalResults';

  // 7. Appeals
  static const String appeals = '/api/Appeals';
  static const String myTeamAppeals = '/api/Appeals/my-team';
  static const String teamAppeals = '/api/Appeals/team';
}
