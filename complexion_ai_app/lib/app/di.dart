import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/network/api_client.dart';

// Auth
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/sign_in.dart';
import '../features/auth/domain/usecases/sign_up.dart';
import '../features/auth/domain/usecases/sign_out.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

// Profile
import '../features/profile/data/datasources/profile_remote_datasource.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/domain/usecases/update_skin_profile.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';

// Skin Analysis
import '../features/skin_analysis/data/datasources/analysis_remote_datasource.dart';
import '../features/skin_analysis/data/repositories/analysis_repository_impl.dart';
import '../features/skin_analysis/domain/repositories/analysis_repository.dart';
import '../features/skin_analysis/domain/usecases/capture_and_analyse.dart';
import '../features/skin_analysis/domain/usecases/get_analysis_history.dart';
import '../features/skin_analysis/presentation/bloc/analysis_bloc.dart';

// Routine
import '../features/routine/data/datasources/routine_remote_datasource.dart';
import '../features/routine/data/repositories/routine_repository_impl.dart';
import '../features/routine/domain/repositories/routine_repository.dart';
import '../features/routine/domain/usecases/get_routines.dart';
import '../features/routine/domain/usecases/generate_routine.dart';
import '../features/routine/domain/usecases/update_routine.dart';
import '../features/routine/presentation/bloc/routine_bloc.dart';

// Daily Check-in
import '../features/daily_checkin/data/datasources/checkin_remote_datasource.dart';
import '../features/daily_checkin/data/repositories/checkin_repository_impl.dart';
import '../features/daily_checkin/domain/repositories/checkin_repository.dart';
import '../features/daily_checkin/domain/usecases/submit_checkin.dart';
import '../features/daily_checkin/domain/usecases/get_checkin_streak.dart';
import '../features/daily_checkin/presentation/bloc/checkin_bloc.dart';

// AI Chat
import '../features/ai_chat/data/datasources/chat_remote_datasource.dart';
import '../features/ai_chat/data/repositories/chat_repository_impl.dart';
import '../features/ai_chat/domain/repositories/chat_repository.dart';
import '../features/ai_chat/domain/usecases/send_message.dart';
import '../features/ai_chat/domain/usecases/get_chat_history.dart';
import '../features/ai_chat/presentation/bloc/chat_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Supabase client
  final supabase = Supabase.instance.client;
  getIt.registerSingleton<SupabaseClient>(supabase);

  // API Client
  getIt.registerSingleton<ApiClient>(ApiClient(supabase));

  _setupAuth();
  _setupProfile();
  _setupSkinAnalysis();
  _setupRoutine();
  _setupDailyCheckin();
  _setupAiChat();
}

void _setupAuth() {
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<SignIn>(
    () => SignIn(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignUp>(
    () => SignUp(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignOut>(
    () => SignOut(getIt<AuthRepository>()),
  );
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      signIn: getIt<SignIn>(),
      signUp: getIt<SignUp>(),
      signOut: getIt<SignOut>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );
}

void _setupProfile() {
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  );
  getIt.registerLazySingleton<UpdateSkinProfile>(
    () => UpdateSkinProfile(getIt<ProfileRepository>()),
  );
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      updateSkinProfile: getIt<UpdateSkinProfile>(),
      profileRepository: getIt<ProfileRepository>(),
    ),
  );
}

void _setupSkinAnalysis() {
  getIt.registerLazySingleton<AnalysisRemoteDataSource>(
    () => AnalysisRemoteDataSource(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<AnalysisRepository>(
    () => AnalysisRepositoryImpl(getIt<AnalysisRemoteDataSource>()),
  );
  getIt.registerLazySingleton<CaptureAndAnalyse>(
    () => CaptureAndAnalyse(getIt<AnalysisRepository>()),
  );
  getIt.registerLazySingleton<GetAnalysisHistory>(
    () => GetAnalysisHistory(getIt<AnalysisRepository>()),
  );
  getIt.registerFactory<AnalysisBloc>(
    () => AnalysisBloc(
      captureAndAnalyse: getIt<CaptureAndAnalyse>(),
      getAnalysisHistory: getIt<GetAnalysisHistory>(),
    ),
  );
}

void _setupRoutine() {
  getIt.registerLazySingleton<RoutineRemoteDataSource>(
    () => RoutineRemoteDataSource(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<RoutineRepository>(
    () => RoutineRepositoryImpl(getIt<RoutineRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetRoutines>(
    () => GetRoutines(getIt<RoutineRepository>()),
  );
  getIt.registerLazySingleton<GenerateRoutine>(
    () => GenerateRoutine(getIt<RoutineRepository>()),
  );
  getIt.registerLazySingleton<UpdateRoutineStep>(
    () => UpdateRoutineStep(getIt<RoutineRepository>()),
  );
  getIt.registerFactory<RoutineBloc>(
    () => RoutineBloc(
      getRoutines: getIt<GetRoutines>(),
      generateRoutine: getIt<GenerateRoutine>(),
      updateRoutineStep: getIt<UpdateRoutineStep>(),
    ),
  );
}

void _setupDailyCheckin() {
  getIt.registerLazySingleton<CheckinRemoteDataSource>(
    () => CheckinRemoteDataSource(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<CheckinRepository>(
    () => CheckinRepositoryImpl(getIt<CheckinRemoteDataSource>()),
  );
  getIt.registerLazySingleton<SubmitCheckin>(
    () => SubmitCheckin(getIt<CheckinRepository>()),
  );
  getIt.registerLazySingleton<GetCheckinStreak>(
    () => GetCheckinStreak(getIt<CheckinRepository>()),
  );
  getIt.registerFactory<CheckinBloc>(
    () => CheckinBloc(
      submitCheckin: getIt<SubmitCheckin>(),
      getCheckinStreak: getIt<GetCheckinStreak>(),
      checkinRepository: getIt<CheckinRepository>(),
    ),
  );
}

void _setupAiChat() {
  getIt.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSource(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(getIt<ChatRemoteDataSource>()),
  );
  getIt.registerLazySingleton<SendMessage>(
    () => SendMessage(getIt<ChatRepository>()),
  );
  getIt.registerLazySingleton<GetChatHistory>(
    () => GetChatHistory(getIt<ChatRepository>()),
  );
  getIt.registerFactory<ChatBloc>(
    () => ChatBloc(
      sendMessage: getIt<SendMessage>(),
      getChatHistory: getIt<GetChatHistory>(),
      chatRepository: getIt<ChatRepository>(),
    ),
  );
}
