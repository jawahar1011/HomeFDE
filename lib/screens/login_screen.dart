import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController otpController =
  TextEditingController();

  ConfirmationResult? confirmationResult;

  bool otpSent = false;
  bool loading = false;

  // ================= SEND OTP =================

  Future<void> sendOtp() async {

    setState(() {
      loading = true;
    });

    try {

      confirmationResult =
      await FirebaseAuth.instance.signInWithPhoneNumber(
        phoneController.text.trim(),
      );

      setState(() {
        otpSent = true;
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP Sent Successfully"),
        ),
      );

    } on FirebaseAuthException catch (e) {

      setState(() {
        loading = false;
      });

      print("FIREBASE ERROR CODE: ${e.code}");
      print("FIREBASE ERROR MESSAGE: ${e.message}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? e.code,
          ),
        ),
      );

    } catch (e) {

      setState(() {
        loading = false;
      });

      print("GENERAL ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // ================= VERIFY OTP =================

  Future<void> verifyOtp() async {

    setState(() {
      loading = true;
    });

    try {

      await confirmationResult!.confirm(
        otpController.text.trim(),
      );

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful'),
        ),
      );

      // NAVIGATE TO HOME
      Navigator.pushReplacementNamed(
        context,
        '/home',
      );

    } on FirebaseAuthException catch (e) {

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? e.code,
          ),
        ),
      );

    } catch (e) {

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: Center(
        child: Container(
          width: 420,

          padding: const EdgeInsets.all(32),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(24),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Enter your phone number',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              // PHONE FIELD
              TextField(
                controller: phoneController,

                keyboardType: TextInputType.phone,

                decoration: InputDecoration(
                  hintText: '+919999999999',

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),

                    borderSide: const BorderSide(
                      color: Color(0xFF3B4CB8),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // OTP FIELD
              if (otpSent)
                TextField(
                  controller: otpController,

                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                    hintText: 'Enter OTP',

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),

                      borderSide: const BorderSide(
                        color: Color(0xFF3B4CB8),
                        width: 2,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // BUTTON
              SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton(
                  onPressed: loading
                      ? null
                      : otpSent
                      ? verifyOtp
                      : sendOtp,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B4CB8),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: loading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : Text(
                    otpSent
                        ? 'Verify OTP'
                        : 'Send OTP',

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}