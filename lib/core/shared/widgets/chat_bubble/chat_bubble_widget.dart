import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubbleWidget extends StatelessWidget {
  final String message;
  final bool isUserMessage;
  final Color color;

  const ChatBubbleWidget({
    Key? key,
    required this.message,
    this.isUserMessage = false,
    this.color = AppColors.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: BubbleSpecialThree(
          text: message,
          textStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 13.0.sp,
            fontWeight: FontWeight.w400,
            color: isUserMessage ? AppColors.blackColor : AppColors.whiteColor,
          ),
          color: isUserMessage
              ? const Color(0xFFE7E7E7)
              : AppColors.primaryColor.withOpacity(0.9),
          tail: true,
          isSender: isUserMessage,
        ));
  }
}

class TailPainter extends CustomPainter {
  final Color color;
  final bool isUserMessage;

  TailPainter({
    required this.color,
    required this.isUserMessage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isUserMessage) {
      path.moveTo(size.width, 0);
      path.cubicTo(
        size.width + 32,
        size.height * 0.3,
        size.width + 16,
        size.height * 0.7,
        size.width,
        size.height,
      );
    } else {
      path.moveTo(0, 0);
      path.cubicTo(
        -32,
        size.height * 0.3,
        -16,
        size.height * 0.7,
        0,
        size.height,
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Usage remains same as previous example