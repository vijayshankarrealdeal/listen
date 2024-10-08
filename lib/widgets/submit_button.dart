import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // For the CupertinoIcons

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed; // Function passed in the constructor
  final String buttonText;
  final bool showIcon;

  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.showIcon, // Required function
    this.buttonText = "Get OTP", // Default button text
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Use the function passed
      child: Container(
        height: MediaQuery.of(context).size.height * 0.065,
        width: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.green.shade900,
          borderRadius: BorderRadius.circular(18),
        ),
        child: showIcon
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  const Spacer(),
                  showIcon
                      ? const Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            CupertinoIcons.forward,
                            color: Colors.white,
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(width: 5),
                ],
              )
            : Center(
              child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
            ),
      ),
    );
  }
}
