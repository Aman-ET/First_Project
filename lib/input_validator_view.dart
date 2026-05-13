import 'package:flutter/material.dart';



class NameToastScreen extends StatefulWidget {
  const NameToastScreen({super.key});

  @override
  State<NameToastScreen> createState() => _NameToastScreenState();
}

class _NameToastScreenState extends State<NameToastScreen> {


  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscureText = true;

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  String? _nameError, _emailError, _passError;

  @override
  void initState() {
    super.initState();
    // Attach listeners to handle both Gaining and Losing focus
    _nameFocus.addListener(() => _handleFocusChange(_nameFocus, _validateName, (val) => _nameError = val));
    _emailFocus.addListener(() => _handleFocusChange(_emailFocus, _validateEmail, (val) => _emailError = val));
    _passFocus.addListener(() => _handleFocusChange(_passFocus, _validatePassword, (val) => _passError = val));
  }

  // Optimized focus handler
  void _handleFocusChange(FocusNode node, Function validationLogic, Function(String?) errorSetter) {
    setState(() {
      if (node.hasFocus) {
        // 1. IF GAIN FOCUS: Clear the error message immediately
        errorSetter(null);
      } else {
        // 2. IF LOSE FOCUS: Run validation logic
        validationLogic();
      }
    });
  }



  // --- VALIDATION LOGIC ---
  void _validateName() {
    final name = _nameController.text.trim();
    final nameRegExp = RegExp(r"^Mr\.\s[a-zA-Z@\s]{2,50}$");
    if (name.isEmpty) _nameError = "Name is required";
    else if (!nameRegExp.hasMatch(name)) _nameError = "Must start with 'Mr. '";
    else _nameError = null;
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (email.isEmpty) _emailError = "Email is required";
    else if (!emailRegExp.hasMatch(email)) _emailError = "Enter a valid email";
    else _emailError = null;
  }

  void _validatePassword() {
    final pass = _passController.text.trim();
    final passRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    if (pass.isEmpty) _passError = "Password is required";
    else if (!passRegExp.hasMatch(pass)) _passError = "Need Upper, Lower, & Digit (Min 8)";
    else _passError = null;
  }



  @override
  void dispose() {
    _nameFocus.dispose(); _emailFocus.dispose(); _passFocus.dispose();
    _nameController.dispose(); _emailController.dispose(); _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "User Registration",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: const OutlineInputBorder(),
                  errorText: _nameError, // Red text disappears on focus
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                focusNode: _emailFocus,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  errorText: _emailError,
                ),
              ),
              const SizedBox(height: 20),

              // PASSWORD FIELD
              TextField(
                controller: _passController,
                focusNode: _passFocus,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  errorText: _passError,
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                ),
              ),
              ),
                const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // 1. Manually trigger all validation logic
                    _validateName();
                    _validateEmail();
                    _validatePassword();

                    // 2. Check if all text fields are correctly filled (no errors)
                    if (_nameError == null && _emailError == null && _passError == null) {

                      // 3. Show Success Toast using ScaffoldMessenger
                      ScaffoldMessenger.of(context).clearSnackBars(); // Clears any previous toast
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Registration Successful!"),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.white30,
                  foregroundColor: Colors.blue,
                ),
                child: const Text("Submit Registration"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  // 1. Controllers for the three fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // Boolean to toggle password visibility
  bool _obscureText = true;
  String? _nameError;
  String? _emailError;
  String? _passError;

  void _validateAndShow() {
    setState(() {
      final String name = _nameController.text.trim();
      final String email = _emailController.text.trim();
      final String pass = _passController.text.trim();


      // REGEX DEFINITIONS
      final RegExp nameRegExp = RegExp(r"^Mr\.\s[a-zA-Z@\s]{2,50}$");

      // Email: Standard email format validation
      final RegExp emailRegExp = RegExp(
          r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

      // Password: Min 8 chars, at least 1 Uppercase, 1 Lowercase, 1 Number, and 1 Special Char
      final RegExp passRegExp = RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

      // 2. Validate Name
      if (name.isEmpty) {
        _nameError = "Name is required";
      } else if (!nameRegExp.hasMatch(name)) {
        _nameError = "Must start with 'Mr. '";
      } else {
        _nameError = null;
      }

      // 3. Validate Email
      if (email.isEmpty) {
        _emailError = "Email is required";
      } else if (!emailRegExp.hasMatch(email)) {
        _emailError = "Enter a valid email";
      } else {
        _emailError = null;
      }

      // 4. Validate Password
      if (pass.isEmpty) {
        _passError = "Password is required";
      } else if (!passRegExp.hasMatch(pass)) {
        _passError = "Need Upper, Lower, & Digit (Min 8)";
      } else {
        _passError = null;
      }

      // 5. If all null, show success toast
      if (_nameError == null && _emailError == null && _passError == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("All fields valid!"),
              backgroundColor: Colors.green),
        );
      }
    }

    );
  }

    @override
    void dispose() {
      _nameController.dispose();
      _emailController.dispose();
      _passController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "User Registration",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // NAME FIELD
                TextField(
                  controller: _nameController,
                  decoration:  InputDecoration(
                    labelText: 'Name (Mandatory Mr. )',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    errorText: _nameError,
                  ),
                ),
                const SizedBox(height: 16),

                // EMAIL FIELD
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    errorText: _emailError,
                  ),
                ),
                const SizedBox(height: 16),

                // PASSWORD FIELD
                TextField(
                  controller: _passController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    errorText: _passError,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons
                          .visibility),
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _validateAndShow,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Submit & Validate'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } */
  }
