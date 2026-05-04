library arlith_core;

export 'constants/app_strings.dart';
export 'constants/app_constants.dart';
export 'themes/app_colors.dart';
export 'themes/app_theme.dart';
export 'themes/app_text_styles.dart';
export 'utils/app_logger.dart';
export 'services/supabase_service.dart';
export 'models/user_profile.dart';
export 'models/user_role.dart';
export 'widgets/arlith_button.dart';
export 'widgets/arlith_text_field.dart';
export 'injection.dart';

// Auth Feature
export 'features/auth/presentation/pages/login_page.dart';
export 'features/auth/presentation/pages/signup_page.dart';
export 'features/auth/presentation/bloc/auth_bloc.dart';
export 'features/auth/presentation/bloc/auth_event.dart';
export 'features/auth/presentation/bloc/auth_state.dart';
export 'features/auth/domain/repositories/auth_repository.dart';

// User Feature
export 'features/user/presentation/bloc/user_bloc.dart';
export 'features/user/presentation/bloc/user_event.dart';
export 'features/user/presentation/bloc/user_state.dart';
export 'features/user/domain/repositories/user_repository.dart';
export 'features/user/presentation/pages/profile_page.dart';

// Packages
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';
export 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
export 'package:equatable/equatable.dart';
export 'package:dartz/dartz.dart' hide State;
export 'package:flutter_screenutil/flutter_screenutil.dart';
