import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../arlith_core.dart';

class SignupPage extends StatefulWidget {
  final String role;
  final VoidCallback onSignupSuccess;
  final String? initialPhone;

  const SignupPage({
    super.key,
    required this.role,
    required this.onSignupSuccess,
    this.initialPhone,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.initialPhone != null) {
      _phoneController.text = widget.initialPhone!;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.role} ${AppStrings.signup}'),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            widget.onSignupSuccess();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ArlithTextField(
                  controller: _fullNameController,
                  label: AppStrings.fullName,
                  validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
                ),
                SizedBox(height: 16.h),
                ArlithTextField(
                  controller: _emailController,
                  label: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value?.isEmpty ?? true ? 'Email is required' : null,
                ),
                SizedBox(height: 16.h),
                ArlithTextField(
                  controller: _phoneController,
                  label: AppStrings.phone,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16.h),
                ArlithTextField(
                  controller: _passwordController,
                  label: AppStrings.password,
                  isPassword: true,
                  validator: (value) => (value?.length ?? 0) < 6 ? 'Min 6 characters' : null,
                ),
                SizedBox(height: 32.h),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ArlithButton(
                      text: AppStrings.createAccount,
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<AuthBloc>().add(
                                SignUpRequested(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  fullName: _fullNameController.text.trim(),
                                  role: widget.role.toLowerCase(),
                                  phone: _phoneController.text.trim(),
                                ),
                              );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
