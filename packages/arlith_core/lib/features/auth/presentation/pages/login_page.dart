import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../arlith_core.dart';

class LoginPage extends StatefulWidget {
  final String role;
  final VoidCallback onLoginSuccess;

  const LoginPage({
    super.key,
    required this.role,
    required this.onLoginSuccess,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPhoneLogin = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            widget.onLoginSuccess();
          } else if (state is NeedsRegistration) {
            // Redirect to Signup with phone if available
            context.push('/signup', extra: state.phone);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.h1(context),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '${AppStrings.login} as ${widget.role}',
                    style: AppTextStyles.bodyMedium(context),
                  ),
                  SizedBox(height: 32.h),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is OTPCodeSent || state is NeedsRegistration) {
                        return Column(
                          children: [
                            Text(
                              state is OTPCodeSent ? 'OTP sent to ${state.phone}' : 'No account found for this phone.',
                              style: AppTextStyles.bodyMedium(context),
                            ),
                            if (state is OTPCodeSent) ...[
                              SizedBox(height: 16.h),
                              ArlithTextField(
                                controller: _otpController,
                                label: AppStrings.enterOtp,
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 32.h),
                              ArlithButton(
                                text: AppStrings.verifyOtp,
                                isLoading: state is AuthLoading,
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                        OTPVerificationRequested(
                                          state.phone,
                                          _otpController.text.trim(),
                                        ),
                                      );
                                },
                              ),
                            ] else if (state is NeedsRegistration) ...[
                              SizedBox(height: 32.h),
                              ArlithButton(
                                text: 'Complete Registration',
                                onPressed: () {
                                  context.push('/signup', extra: state.phone);
                                },
                              ),
                            ],
                          ],
                        );
                      }

                      return Column(
                        children: [
                          if (!_isPhoneLogin) ...[
                            ArlithTextField(
                              controller: _emailController,
                              label: AppStrings.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Email is required' : null,
                            ),
                            SizedBox(height: 16.h),
                            ArlithTextField(
                              controller: _passwordController,
                              label: AppStrings.password,
                              isPassword: true,
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Password is required' : null,
                            ),
                          ] else ...[
                            ArlithTextField(
                              controller: _phoneController,
                              label: AppStrings.phone,
                              keyboardType: TextInputType.phone,
                              hint: '+1234567890',
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Phone is required' : null,
                            ),
                          ],
                          SizedBox(height: 32.h),
                          ArlithButton(
                            text: _isPhoneLogin ? AppStrings.sendOtp : AppStrings.login,
                            isLoading: state is AuthLoading,
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (_isPhoneLogin) {
                                  context.read<AuthBloc>().add(
                                        PhoneSignInRequested(_phoneController.text.trim()),
                                      );
                                } else {
                                  context.read<AuthBloc>().add(
                                        LoginRequested(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                        ),
                                      );
                                }
                              }
                            },
                          ),
                          SizedBox(height: 16.h),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isPhoneLogin = !_isPhoneLogin;
                              });
                            },
                            child: Text(
                              _isPhoneLogin
                                  ? AppStrings.useEmailLogin
                                  : AppStrings.usePhoneLogin,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push('/signup');
                            },
                            child: Text(
                              AppStrings.dontHaveAccount,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
