import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/addProduct/presentation/cubit/add_product_cubit.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/add_product_authentication_section.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/add_product_details_section.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/add_product_form_section.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/add_product_price_image_section.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/add_product_submit_button_bloc.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/add_product_text_field.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/core/NetWork/api_service.dart';

import 'package:mega_cart/features/splashScreen/view/session_manager.dart';
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
  final TextEditingController _stockController = TextEditingController();
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
    _stockController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final token = await SessionManager.getToken();
    if (token != null && token.isNotEmpty) {
      _tokenController.text = token;
    }
    // Set a default seller ID for convenience during development
    _sellerIdController.text = 'd051dbf3-f5d8-410d-0e50-08de06562562';
    _stockController.text = '1'; // Default stock
  }

  void _submitForm(BuildContext context) async {
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
        stock: int.tryParse(_stockController.text.trim()),
        coverPictureUrl: _coverImageUrlController.text.trim(),
        token: _tokenController.text.trim().isEmpty
            ? null
            : _tokenController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Initialize Dio and ApiService here or inject them
        // For simplicity, re-initializing here. In a real app, use dependency injection.
        final dio = Dio(
          BaseOptions(baseUrl: 'https://accessories-eshop.runasp.net/api/'),
        );
        final apiService = ApiService(
          dio,
        ); // Token will be passed directly to cubit
        final productRepository = ProductRepositoryImpl(apiService);
        return AddProductCubit(productRepository);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('إضافة منتج جديد'), centerTitle: true),
        body: BlocConsumer<AddProductCubit, AddProductState>(
          listener: (context, state) {
            if (state.status == AddProductStatus.success) {
              GlassSnackbar.show(message: 'تمت إضافة المنتج بنجاح');
              Get.back(result: true);
            } else if (state.status == AddProductStatus.error) {
              GlassSnackbar.show(
                message: state.errorMessage ?? 'Unknown Error',
                isError: true,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  // Changed to Column to hold multiple sections
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddProductAuthenticationSection(
                      sellerIdController: _sellerIdController,
                      tokenController: _tokenController,
                    ),
                    AddProductDetailsSection(
                      nameController: _nameController,
                      descriptionController: _descriptionController,
                      nameArabicController: _nameArabicController,
                      descriptionArabicController: _descriptionArabicController,
                    ),
                    AddProductPriceImageSection(
                      priceController: _priceController,
                      coverImageUrlController: _coverImageUrlController,
                    ),
                    const SizedBox(height: 32),
                    // Add stock field
                    AddProductFormSection(
                      title: 'المخزون',
                      children: [
                        AddProductTextField(
                          controller: _stockController,
                          labelText: 'الكمية المتوفرة',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    AddProductSubmitButtonBloc(
                      isLoading: state.status == AddProductStatus.loading,
                      onPressed: () => _submitForm(context),
                      buttonText: 'إضافة المنتج',
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
