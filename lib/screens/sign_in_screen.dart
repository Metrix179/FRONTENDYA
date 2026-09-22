import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/topo_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/auth_tabs.dart';
import 'auth_choice_screen.dart';
import 'sign_up_screen.dart';
import 'main_scaffold.dart';

class SignInScreen extends StatefulWidget {
  final UserRole role;

  const SignInScreen({super.key, required this.role});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isParent = widget.role == UserRole.parent;
    final title = isParent ? 'Welcome Back' : 'Clinical Sign In';
    final subtitle = isParent
        ? 'Sign in to view growth insights & nutrition status.'
        : 'Sign in to access patient & child health records.';
    final idLabel = isParent ? 'CHILD ID' : 'HOSPITAL ID';
    final idHint = isParent ? 'e.g. PE-1048' : 'e.g. HID-2341';
    final idIcon = isParent
        ? Icons.verified_user_outlined
        : Icons.local_hospital_outlined;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 20, top: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.arrow_back_rounded,
                        size: 18,
                        color: AppColors.textDark,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Back',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Header
              TopoHeader(
                title: title,
                subtitle: subtitle,
              ),
              const SizedBox(height: 28),

              // Form fields
              CustomTextField(
                label: idLabel,
                hint: idHint,
                controller: _idController,
                prefixIcon: Icon(idIcon, color: AppColors.textSubtle, size: 22),
              ),
              const SizedBox(height: 18),

              CustomTextField(
                label: 'PASSWORD',
                hint: 'Enter password',
                controller: _passwordController,
                isPassword: true,
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.textSubtle,
                  size: 22,
                ),
              ),
              const SizedBox(height: 24),

              // Tabs
              AuthTabs(
                isSignIn: true,
                onTabChanged: (isSignIn) {
                  if (!isSignIn) {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SignUpScreen(role: widget.role),
                        transitionDuration: Duration.zero,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              // Continue CTA
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final childName = widget.role == UserRole.parent ? 'Aarav' : 'Dr. Priya';
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MainScaffold(childName: childName),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForest,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
