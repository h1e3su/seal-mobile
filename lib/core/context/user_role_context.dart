import 'package:flutter/material.dart';
import '../../data/models/event_role/event_role_model.dart';

enum ActiveRoleType { student, mentor }

class ActiveRole {
  final String eventId;
  final String eventName;
  final ActiveRoleType type;
  final String? trackId;
  final String? trackName;
  final String? teamId;
  final String? teamName;

  ActiveRole({
    required this.eventId,
    required this.eventName,
    required this.type,
    this.trackId,
    this.trackName,
    this.teamId,
    this.teamName,
  });
}

class UserRoleContext extends ChangeNotifier {
  List<ActiveRole> _availableRoles = [];
  ActiveRole? _currentRole;

  List<ActiveRole> get availableRoles => _availableRoles;
  ActiveRole? get currentRole => _currentRole;
  bool get hasMultipleRoles => _availableRoles.length > 1;
  bool get hasNoRoles => _availableRoles.isEmpty;

  void setRoles(List<EventRoleModel> rawRoles) {
    _availableRoles = rawRoles
        .map((r) => ActiveRole(
              eventId: r.eventId,
              eventName: r.eventName,
              type: r.isMentor ? ActiveRoleType.mentor : ActiveRoleType.student,
              trackId: r.trackId,
              trackName: r.trackName,
              teamId: r.teamId,
              teamName: r.teamName,
            ))
        .toList();
    _currentRole = _availableRoles.isNotEmpty ? _availableRoles.first : null;
    notifyListeners();
  }

  void switchRole(ActiveRole role) {
    _currentRole = role;
    notifyListeners();
  }

  /// Reset context when logging out
  void clear() {
    _availableRoles = [];
    _currentRole = null;
    notifyListeners();
  }
}
