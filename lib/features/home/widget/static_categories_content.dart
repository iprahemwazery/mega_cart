import 'package:flutter/material.dart';

class StaticCategoriesContent extends StatelessWidget {
  const StaticCategoriesContent({super.key});

  // داتا ثابتة بنفس بيانات الصورة بالظبط للتجربة المعاينة
  final List<Map<String, String>> dummyCategories = const [
    {
      "name": "New Arrivals",
      "description":
          "208 Product", // تم تغيير "count" إلى "description" ليتناسب مع النموذج
      "coverPictureUrl":
          "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=500", // صورة تيشيرت أسود
    },
    {
      "name": "Clothes",
      "description": "358 Product",
      "coverPictureUrl":
          "https://images.unsplash.com/photo-1529139574466-a303027c1d8b?q=80&w=500", // صورة تيشيرت فسفوري/أخضر
    },
    {
      "name": "Bags",
      "description": "160 Product",
      "coverPictureUrl":
          "https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=500", // صورة حقيبة يد
    },
    {
      "name": "Shoes",
      "description": "230 Product",
      "coverPictureUrl":
          "https://images.unsplash.com/photo-1549298916-b41d501d3772?q=80&w=600&auto=format&fit=crop", // صورة حذاء رياضي
    },
    {
      "name": "Electronics",
      "description": "170 Product",
      "coverPictureUrl":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=500", // صورة سماعات الرأس
    },
    {
      "name": "Accessories",
      "description": "145 Product",
      "coverPictureUrl":
          "https://images.unsplash.com/photo-1576053139778-7e32f2ae3cfd?q=80&w=500",
    },
    {
      "name": "Watches",
      "description": "85 Product",
      "coverPictureUrl":
          "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=600&auto=format&fit=crop",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0.0,
        ), // الهامش الأفقي سيتم التحكم به من HomeView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // قائمة الأقسام المكررة بناءً على الداتا فوق
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyCategories.length,
              itemBuilder: (context, index) {
                final category = dummyCategories[index];
                return _buildCategoryCard(category, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  // تصميم كارت القسم التبادلي الاحترافي
  Widget _buildCategoryCard(Map<String, String> category, int index) {
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
              child: Image.network(
                category['coverPictureUrl']!,
                fit: BoxFit.cover,
              ),
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
                      category['name']!,
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
                      category['description']!,
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
