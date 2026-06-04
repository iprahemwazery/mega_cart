import 'package:flutter/material.dart';
import 'package:mega_cart/core/models/category.dart';

class StaticCategoriesContent extends StatelessWidget {
  const StaticCategoriesContent({super.key});

  @override
  Widget build(BuildContext context) {
    // هذا الـ Widget أصبح الآن مجرد مكان لتحديد شكل الكارد الواحد
    // عملية بناء القائمة ستتم في _buildCategoriesContent في HomeView
    // لذلك، يمكن أن يعود بـ SizedBox.shrink() أو يتم إزالته إذا لم يكن له استخدام آخر
    return const SizedBox.shrink();
  }

  // تصميم كارت القسم التبادلي الاحترافي
  static Widget buildCategoryCard(Category category, int index) {
    bool isEven = index % 2 == 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 160,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // الصورة تأخذ كامل مساحة الكارت كخلفية
            Positioned.fill(
              child: Image.network(category.coverPictureUrl, fit: BoxFit.cover),
            ),
            // طبقة تدرج لوني غامقة من الأسفل لضمان وضوح النص الأبيض
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
            ),
            // النصوص فوق الصورة في الركن السفلي
            Align(
              alignment: isEven ? Alignment.bottomRight : Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: isEven
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      category.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
