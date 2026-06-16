import 'package:flutter/material.dart';

class AddProductSubmitButtonBloc extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String buttonText;

  const AddProductSubmitButtonBloc({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.buttonText = 'إضافة المنتج',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(buttonText),
      ),
    );
  }
}
