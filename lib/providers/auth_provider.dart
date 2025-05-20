import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';  // Add this import

class AuthState {
  final bool isLoading;
  final String? userId;
  final String? userFullName;
  final String? userEmail;
  final String? userAddress;
  final String? userLocation;

  const AuthState({
    this.isLoading = false,
    this.userId,
    this.userFullName,
    this.userEmail,
    this.userAddress,
    this.userLocation,
  });

  AuthState copyWith({
    bool? isLoading,
    String? userId,
    String? userFullName,
    String? userEmail,
    String? userAddress,
    String? userLocation,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      userFullName: userFullName ?? this.userFullName,
      userEmail: userEmail ?? this.userEmail,
      userAddress: userAddress?? this.userAddress,
      userLocation: userLocation ?? this.userLocation,
    );
  }

  // For backward compatibility with existing screens
  String? get user => userFullName;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> login(String username, String password, {required VoidCallback onSuccess}) async {
    try {
      state = state.copyWith(isLoading: true);
      await Future.delayed(const Duration(seconds: 2)); // Simulate API

      if (username == 'user' && password == 'password') {
        final location = await _getCurrentLocation();
        state = AuthState(
          isLoading: false,
          userId: '1',
          userFullName: 'Ahmed',
          userEmail: 'Ahmed@example.com',
          userAddress: '123 makkah altayyab street near bin-dowood',
          userLocation: location,
        );
        Fluttertoast.showToast(msg: 'Login Successful. Welcome back, $username!');
        onSuccess();
      } else {
        state = state.copyWith(isLoading: false);
        Fluttertoast.showToast(msg: 'Login Failed. Invalid credentials.', backgroundColor: Colors.red);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      Fluttertoast.showToast(msg: 'An error occurred during login', backgroundColor: Colors.red);
    }
  }

  Future<void> logout() async {
    state = const AuthState();
    Fluttertoast.showToast(msg: 'You have been logged out.');
  }

  Future<void> updateProfile(String name) async {
    state = state.copyWith(userFullName: name);
    Fluttertoast.showToast(msg: 'Your profile has been updated successfully.');
  }

  Future<void> updateLocation() async {
    try {
      final location = await _getCurrentLocation();
      if (location != null) {
        state = state.copyWith(userLocation: location);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to update location', backgroundColor: Colors.red);
    }
  }

  Future<String?> _getCurrentLocation() async {
    try {
      final status = await Permission.location.request();
      if (!status.isGranted) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.locality}, ${place.administrativeArea}';
      }
      return 'Lat: ${position.latitude}, Long: ${position.longitude}';
    } catch (e) {
      debugPrint('Location error: $e');
      return null;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());