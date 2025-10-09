import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/modern_widgets.dart';
import '../../utils/animation_helpers.dart';
import '../../utils/visual_effects.dart';
import '../../utils/haptic_feedback_helper.dart';
import '../../utils/sound_effects_helper.dart';
import '../../utils/responsive_helper.dart';
import '../../utils/security_helper.dart';
import '../../utils/error_handler.dart';
import '../../config/app_constants.dart';
import 'register_screen.dart';

class ModernLoginScreen extends StatefulWidget {
  const ModernLoginScreen({super.key});

  @override
  State<ModernLoginScreen> createState() => _ModernLoginScreenState();
}

class _ModernLoginScreenState extends State<ModernLoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.longAnimation,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedbackHelper.error();
      SoundEffectsHelper.playError();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    HapticFeedbackHelper.buttonPress();
    SoundEffectsHelper.playButtonClick();

    try {
      final email = SecurityHelper.sanitizeInput(_emailController.text.trim());
      final password = _passwordController.text;

      final user = await _authService.signInWithEmailAndPassword(email, password);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (user != null) {
          HapticFeedbackHelper.success();
          SoundEffectsHelper.playSuccess();
          
          ModernWidgets.showModernSnackBar(
            context: context,
            message: 'Welcome back! 👋',
            type: SnackBarType.success,
          );
        } else {
          _handleLoginError('Invalid credentials');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        final errorMessage = ErrorHandler.getErrorMessage(e.toString());
        _handleLoginError(errorMessage);
      }
    }
  }

  void _handleLoginError(String message) {
    HapticFeedbackHelper.error();
    SoundEffectsHelper.playError();
    
    ModernWidgets.showModernSnackBar(
      context: context,
      message: message,
      type: SnackBarType.error,
      actionLabel: 'Retry',
      onActionPressed: () {
        _emailController.clear();
        _passwordController.clear();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernWidgets.loadingOverlay(
        isLoading: _isLoading,
        loadingText: 'Signing you in...',
        child: VisualEffects.gradientBackground(
          colors: [
            AppColors.backgroundGradientStart,
            AppColors.backgroundGradientEnd,
          ],
          child: ResponsiveHelper.safeAreaWrapper(
            child: ResponsiveContainer(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Modern Logo with enhanced design
                      AnimationHelpers.scaleTransition(
                        child: Column(
                          children: [
                            VisualEffects.glowEffect(
                              glowColor: AppColors.primaryPurple,
                              child: Container(
                                width: ResponsiveHelper.responsive(
                                  context: context,
                                  mobile: 120.0,
                                  tablet: 140.0,
                                ),
                                height: ResponsiveHelper.responsive(
                                  context: context,
                                  mobile: 120.0,
                                  tablet: 140.0,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppColors.primaryPurple, AppColors.lightPurple],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(AppConstants.largePadding),
                                  boxShadow: VisualEffects.modernShadow(
                                    color: AppColors.primaryPurple,
                                    opacity: 0.4,
                                    blurRadius: 25,
                                    offset: const Offset(0, 15),
                                  ),
                                ),
                                child: Icon(
                                  Icons.photo_camera_rounded,
                                  color: Colors.white,
                                  size: ResponsiveHelper.responsiveIconSize(context) * 2,
                                ),
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.responsive(
                              context: context,
                              mobile: 40.0,
                              tablet: 50.0,
                            )),
                            Text(
                              'Locket Widget',
                              style: AppTextStyles.headline1.copyWith(
                                fontSize: ResponsiveHelper.responsiveTextSize(
                                  context: context,
                                  baseSize: 42,
                                ),
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryPurple,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Share moments with your closest friends',
                              style: AppTextStyles.body1.copyWith(
                                fontSize: ResponsiveHelper.responsiveTextSize(
                                  context: context,
                                  baseSize: 18,
                                ),
                                color: AppColors.grey,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.responsive(
                        context: context,
                        mobile: 60.0,
                        tablet: 80.0,
                      )),

                      // Modern Email field
                      AnimationHelpers.slideTransition(
                        begin: const Offset(-1, 0),
                        child: ModernWidgets.modernTextField(
                          label: 'Email Address',
                          controller: _emailController,
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          style: TextFieldStyle.elevated,
                          enabled: !_isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!SecurityHelper.isValidEmail(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.responsive(
                        context: context,
                        mobile: 24.0,
                        tablet: 32.0,
                      )),

                      // Modern Password field
                      AnimationHelpers.slideTransition(
                        begin: const Offset(1, 0),
                        child: ModernWidgets.modernTextField(
                          label: 'Password',
                          controller: _passwordController,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          obscureText: _obscurePassword,
                          style: TextFieldStyle.elevated,
                          enabled: !_isLoading,
                          onSuffixIconPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                            HapticFeedbackHelper.light();
                            SoundEffectsHelper.playToggle();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.responsive(
                        context: context,
                        mobile: 40.0,
                        tablet: 50.0,
                      )),

                      // Modern Login Button
                      AnimationHelpers.scaleTransition(
                        child: ModernWidgets.gradientButton(
                          text: 'Sign In',
                          icon: Icons.login_rounded,
                          isLoading: _isLoading,
                          height: ResponsiveHelper.responsiveButtonHeight(context),
                          onPressed: _isLoading ? () {} : _login,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.responsive(
                        context: context,
                        mobile: 32.0,
                        tablet: 40.0,
                      )),

                      // Modern Register Link
                      AnimationHelpers.fadeTransition(
                        child: GestureDetector(
                          onTap: _isLoading ? null : () {
                            HapticFeedbackHelper.light();
                            SoundEffectsHelper.playNavigation();
                            Navigator.push(
                              context,
                              ModernPageRoute(
                                child: const RegisterScreen(),
                                direction: SlideDirection.left,
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.responsive(
                                context: context,
                                mobile: 20.0,
                                tablet: 24.0,
                              ),
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: AppTextStyles.body1.copyWith(
                                  color: AppColors.grey,
                                  fontSize: ResponsiveHelper.responsiveTextSize(
                                    context: context,
                                    baseSize: 16,
                                  ),
                                ),
                                children: [
                                  const TextSpan(text: "Don't have an account? "),
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: AppTextStyles.body1.copyWith(
                                      color: AppColors.primaryPurple,
                                      fontWeight: FontWeight.w700,
                                      fontSize: ResponsiveHelper.responsiveTextSize(
                                        context: context,
                                        baseSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}