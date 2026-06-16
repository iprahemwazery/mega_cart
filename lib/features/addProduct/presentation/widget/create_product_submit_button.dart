import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' show Trans;
import 'package:mega_cart/core/utils/app_text_styles.dart';
import 'package:mega_cart/features/addProduct/presentation/cubit/add_product_cubit.dart';

class CreateProductSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateProductSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AddProductCubit, AddProductState>(
      builder: (context, state) {
        final isLoading = state.status == AddProductStatus.loading;
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text('createProductButton'.tr, style: AppTextStyles.button),
          ),
        );
      },
    );
  }
}
