import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart'; // لاستخدام Get.snackbar
import 'package:dio/dio.dart'; // لتهيئة Dio
import 'package:mega_cart/core/NetWork/add_product_cubit.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/core/NetWork/api_service.dart';
import 'package:mega_cart/features/singelProfuct/data/product_repository.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sellerIdController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameArabicController = TextEditingController();
  final TextEditingController _descriptionArabicController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _coverImageUrlController =
      TextEditingController();

  @override
  void dispose() {
    _sellerIdController.dispose();
    _tokenController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _nameArabicController.dispose();
    _descriptionArabicController.dispose();
    _priceController.dispose();
    _coverImageUrlController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = context.read<AddProductCubit>();
      cubit.submitProduct(
        sellerId: _sellerIdController.text.trim().isEmpty
            ? ""
            : _sellerIdController.text.trim(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        nameArabic: _nameArabicController.text.trim().isEmpty
            ? ""
            : _nameArabicController.text.trim(),
        descriptionArabic: _descriptionArabicController.text.trim().isEmpty
            ? ""
            : _descriptionArabicController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        coverPictureUrl: _coverImageUrlController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // تهيئة الـ Dependencies هنا (يمكن استخدام GetIt أو Provider لإدارة أفضل)
        final dio = Dio(
          BaseOptions(baseUrl: 'https://accessories-eshop.runasp.net/api/'),
        );
        final apiService = ApiService(
          dio,
          token: _tokenController.text.trim().isEmpty
              ? null
              : _tokenController.text.trim(),
        );
        final productRepository = ProductRepositoryImpl(apiService);
        return AddProductCubit(productRepository);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('إضافة منتج جديد'), centerTitle: true),
        body: BlocConsumer<AddProductCubit, AddProductState>(
          listener: (context, state) {
            if (state is AddProductSuccess) {
              GlassSnackbar.show(message: 'تمت إضافة المنتج بنجاح');
              // مسح الحقول بعد الإضافة بنجاح
              _sellerIdController.clear();
              _tokenController.clear();
              _nameController.clear();
              _descriptionController.clear();
              _nameArabicController.clear();
              _descriptionArabicController.clear();
              _priceController.clear();
              _coverImageUrlController.clear();
            } else if (state is AddProductError) {
              GlassSnackbar.show(message: state.message, isError: true);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _sellerIdController,
                      decoration: const InputDecoration(
                        labelText: 'معرف البائع (Seller ID) - اختياري',
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'الرجاء إدخال معرف البائع';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tokenController,
                      decoration: const InputDecoration(
                        labelText: 'Token (اختياري)',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم المنتج (إنجليزي)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال اسم المنتج';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'وصف المنتج (إنجليزي)',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال وصف المنتج';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameArabicController,
                      decoration: const InputDecoration(
                        labelText: 'اسم المنتج (عربي) - اختياري',
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'الرجاء إدخال اسم المنتج بالعربية';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionArabicController,
                      decoration: const InputDecoration(
                        labelText: 'وصف المنتج (عربي) - اختياري',
                      ),
                      maxLines: 3,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'الرجاء إدخال وصف المنتج بالعربية';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'السعر'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال السعر';
                        }
                        if (double.tryParse(value) == null) {
                          return 'الرجاء إدخال سعر صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _coverImageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'رابط صورة الغلاف',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رابط صورة الغلاف';
                        }
                        final uri = Uri.tryParse(value);
                        if (uri == null || !uri.isAbsolute) {
                          return 'الرجاء إدخال رابط صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    state is AddProductLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => _submitForm(context),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text('إضافة المنتج'),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
