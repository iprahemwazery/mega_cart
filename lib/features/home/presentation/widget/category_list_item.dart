import 'package:flutter/material.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({Key? key}) : super(key: key);

  // داتا ثابتة بنفس بيانات الصورة بالظبط للتجربة المعاينة
  final List<Map<String, String>> dummyCategories = const [
    {
      "name": "New Arrivals",
      "count": "208 Product",
      "image":
          "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=500", // صورة تيشيرت أسود
    },
    {
      "name": "Clothes",
      "count": "358 Product",
      "image":
          "https://images.unsplash.com/photo-1529139574466-a303027c1d8b?q=80&w=500", // صورة تيشيرت فسفوري/أخضر
    },
    {
      "name": "Bags",
      "count": "160 Product",
      "image":
          "https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=500", // صورة حقيبة يد
    },
    {
      "name": "Shoes",
      "count": "230 Product",
      "image":
          "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=500", // صورة حذاء رياضي
    },
    {
      "name": "Electronics",
      "count": "170 Product",
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=500", // صورة سماعات الرأس
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(), // الجزء العلوي (الاسم والاشعارات)
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              const SizedBox(height: 20),
              // قائمة الأقسام المكررة بناءً على الداتا فوق
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dummyCategories.length,
                itemBuilder: (context, index) {
                  final category = dummyCategories[index];
                  // سطر سحري: لو الـ index زوجي الصورة هتبقى يمين، لو فردي الصورة هتبقى شمال
                  bool isImageOnRight = index % 2 == 0;
                  return _buildCategoryCard(category, isImageOnRight);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // الـ AppBar العلوي
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
            ), // صورة المستخدم
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Hi, Jonathan',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Let's go shopping",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // تصميم كارت القسم التبادلي الاحترافي
  Widget _buildCategoryCard(Map<String, String> category, bool isImageOnRight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 130,
      decoration: BoxDecoration(
        color: const Color(
          0xFFEFEFEF,
        ), // نفس الخلفية الرمادي الهادية اللي في الصورة
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // لو الصورة مش يمين (يعني شمال)، اعرض الصورة أولاً
            if (!isImageOnRight) _buildCategoryImage(category['image']!),

            // جزء النصوص (الاسم والعدد)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: isImageOnRight
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Text(
                      category['name']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category['count']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // لو الصورة يمين، اعرض الصورة في الآخر
            if (isImageOnRight) _buildCategoryImage(category['image']!),
          ],
        ),
      ),
    );
  }

  // ويدجت مخصصة لقص وعرض الصورة من الروابط
  Widget _buildCategoryImage(String imageUrl) {
    return SizedBox(
      width: 150,
      height: double.infinity,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }
}
