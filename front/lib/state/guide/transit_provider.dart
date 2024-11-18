// lib/providers/guide/transit_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../services/guide/transit_service.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final transitServiceProvider = Provider<TransitService>((ref) {
  final dio = ref.watch(dioProvider);
  return TransitService(dio);
});