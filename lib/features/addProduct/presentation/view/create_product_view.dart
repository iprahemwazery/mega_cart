import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mega_cart/core/NetWork/api_service.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/features/addProduct/data/model/add_product_repository_impl.dart';
import 'package:mega_cart/features/addProduct/doman/add_product_usecase.dart';

import 'package:mega_cart/features/addProduct/presentation/cubit/add_product_cubit.dart';
import 'package:mega_cart/core/utils/app_text_styles.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/category_selection_section.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/create_product_section.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/create_product_submit_button.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/create_product_text_field.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/image_preview_widget.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/picture_urls_section.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/quick_actions_section.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';

class CreateProductView extends StatefulWidget {
  const CreateProductView({super.key});

  @override
  State<CreateProductView> createState() => _CreateProductViewState();
}

class _CreateProductViewState extends State<CreateProductView> {
  final _formKey = GlobalKey<FormState>(); // Added Form Key
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final nameArabicController = TextEditingController();
  final descriptionArabicController = TextEditingController();
  final coverPictureUrlController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final discountController = TextEditingController();
  final weightController = TextEditingController();
  final colorController = TextEditingController();
  final tokenController = TextEditingController();
  final sellerIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final token = await SessionManager.getToken();
    if (token != null) tokenController.text = token;
    sellerIdController.text = 'd051dbf3-f5d8-410d-0e50-08de06562562';
    stockController.text = '1';
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    nameArabicController.dispose();
    descriptionArabicController.dispose();
    coverPictureUrlController.dispose();
    priceController.dispose();
    stockController.dispose();
    discountController.dispose();
    weightController.dispose();
    colorController.dispose();
    tokenController.dispose();
    sellerIdController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      // Validate form
      context.read<AddProductCubit>().submitProduct(
        sellerId: sellerIdController.text.trim(),
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        nameArabic: nameArabicController.text.trim(),
        descriptionArabic: descriptionArabicController.text.trim(),
        price: double.tryParse(priceController.text.trim()) ?? 0.0,
        coverPictureUrl: coverPictureUrlController.text.trim(),
        stock: int.tryParse(stockController.text.trim()),
        weight: double.tryParse(weightController.text.trim()),
        color: colorController.text.trim(),
        discountPercentage: int.tryParse(discountController.text.trim()),
        token: tokenController.text.trim().isEmpty
            ? null
            : tokenController.text.trim(),
      );
    } else {
      // Optionally show a general error if form is invalid
      GlassSnackbar.show(
        message: 'الرجاء إدخال جميع الحقول المطلوبة بشكل صحيح'.tr,
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) {
        final apiService = ApiService(
          Dio(BaseOptions(baseUrl: ApiConstans.baseUrl)),
        );
        final repository = AddProductRepositoryImpl(apiService);
        final useCase = AddProductUseCase(repository);
        return AddProductCubit(useCase);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('createProductTitle'.tr),
          centerTitle: true,
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onSurface,
          elevation: 0,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BlocConsumer<AddProductCubit, AddProductState>(
          listener: (context, state) {
            if (state.status == AddProductStatus.success) {
              // عرض السناك بار الزجاجي عند النجاح
              GlassSnackbar.show(message: 'productCreatedSuccessMessage'.tr);

              // الرجوع للشاشة السابقة بعد نجاح الإضافة
              Get.back(result: true);
            } else if (state.status == AddProductStatus.error) {
              // عرض رسالة الخطأ في حالة الفشل
              GlassSnackbar.show(
                message: state.errorMessage ?? 'error'.tr,
                isError: true,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                // Added Form widget
                key: _formKey, // Linked form key
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuickActionsSection(
                      onAction: () =>
                          setState(() {}), // تحديث الحالة فور الملء التلقائي
                      cubit: context.read<AddProductCubit>(),
                      nameController: nameController,
                      descriptionController: descriptionController,
                      nameArabicController: nameArabicController,
                      descriptionArabicController: descriptionArabicController,
                      coverPictureUrlController: coverPictureUrlController,
                      priceController: priceController,
                      stockController: stockController,
                      discountController: discountController,
                      weightController: weightController,
                      colorController: colorController,
                      tokenController: tokenController,
                      sellerIdController: sellerIdController,
                    ),
                    const SizedBox(height: 24),
                    CreateProductSection(
                      title: 'createProductTitle'.tr,
                      children: [
                        // Pass controllers and validators
                        CreateProductTextField(
                          controller: nameController,
                          label: 'productNameLabel'.tr,
                          hint: 'productNameHintEnglish'.tr,
                          validator: (value) => value == null || value.isEmpty
                              ? 'productNameRequired'.tr
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CreateProductTextField(
                          controller: nameArabicController,
                          label: 'productNameLabelArabic'.tr,
                          hint: 'productNameHintArabic'.tr,
                        ),
                        const SizedBox(height: 16),
                        CreateProductTextField(
                          controller: descriptionController,
                          label: 'descriptionLabel'.tr,
                          hint: 'descriptionHintEnglish'.tr,
                          maxLines: 3,
                          validator: (value) => value == null || value.isEmpty
                              ? 'productDescriptionRequired'.tr
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CreateProductTextField(
                          controller: descriptionArabicController,
                          label: 'descriptionLabelArabic'.tr,
                          hint: 'descriptionHintArabic'.tr,
                          maxLines: 3,
                        ),
                      ],
                    ),
                    CreateProductSection(
                      title: 'priceLabel'.tr,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CreateProductTextField(
                                controller: priceController,
                                label: 'priceLabel'.tr,
                                hint: '99.99',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'priceRequired'.tr;
                                  if (double.tryParse(value) == null)
                                    return 'invalidPrice'.tr;
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CreateProductTextField(
                                controller: discountController,
                                label: 'discountPercentageLabel'.tr,
                                hint: '5',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      int.tryParse(value) == null)
                                    return 'invalidDiscount'.tr;
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CreateProductTextField(
                                controller: stockController,
                                label: 'stockLabel'.tr,
                                hint: '100',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'stockRequired'.tr;
                                  if (int.tryParse(value) == null)
                                    return 'invalidStock'.tr;
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CreateProductTextField(
                                controller: weightController,
                                label: 'weightLabel'.tr,
                                hint: '1.5',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      double.tryParse(value) == null)
                                    return 'invalidWeight'.tr;
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CreateProductTextField(
                          controller: colorController,
                          label: 'colorLabel'.tr,
                          hint: 'colorHint'.tr,
                        ),
                      ],
                    ),
                    CreateProductSection(
                      title: 'mainImageUrlLabel'.tr,
                      children: [
                        CreateProductTextField(
                          controller: coverPictureUrlController,
                          label: 'mainImageUrlLabel'.tr,
                          hint: 'https://example.com/image.jpg',
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'coverImageUrlRequired'.tr;
                            if (!GetUtils.isURL(value)) return 'invalidUrl'.tr;
                            return null;
                          },
                        ),
                        ImagePreviewWidget(
                          controller: coverPictureUrlController,
                        ),
                      ],
                    ),
                    CreateProductSection(
                      title: 'productCategoriesTitle'.tr,
                      children: [CategorySelectionSection()],
                    ),
                    CreateProductSection(
                      title: 'additionalImageUrlsTitle'.tr,
                      children: [PictureUrlsSection()],
                    ),
                    CreateProductSection(
                      title: 'authenticationInfoTitle'.tr,
                      children: [
                        CreateProductTextField(
                          controller: tokenController,
                          label: 'tokenLabelOptional'.tr,
                          hint: 'tokenHint'.tr,
                        ),
                        const SizedBox(height: 16),
                        CreateProductTextField(
                          controller: sellerIdController,
                          label: 'sellerIdLabelRequired'
                              .tr, // Changed label to reflect it's required
                          hint: 'd051dbf3-f5d8-410d-0e50-08de06562562',
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'sellerIdRequired'.tr;
                            final uuidRegex = RegExp(
                              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
                            );
                            if (!uuidRegex.hasMatch(value)) {
                              return 'invalidSellerIdFormatError'.tr;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'sellerIdRequiredMessage'.tr,
                          style: AppTextStyles.hint.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CreateProductSubmitButton(
                      onPressed: () => _onSubmit(context),
                    ),
                    const SizedBox(height: 32),
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
