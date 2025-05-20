import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

final authNotifierProvider = Provider<AuthNotifier>((ref) {
  // This will be overridden in the main app setup
  throw UnimplementedError('AuthNotifierProvider must be overridden');
});