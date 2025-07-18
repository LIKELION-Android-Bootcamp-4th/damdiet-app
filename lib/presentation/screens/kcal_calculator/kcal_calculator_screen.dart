import 'package:damdiet/core/widgets/underline_text.dart';
import 'package:damdiet/presentation/screens/kcal_calculator/kcal_calculator_viewmodel.dart';
import 'package:damdiet/presentation/screens/kcal_calculator/widgets/kcal_checked_list.dart';
import 'package:damdiet/presentation/screens/kcal_calculator/widgets/kcal_listview_item.dart';
import 'package:damdiet/presentation/screens/auth/widgets/custom_textfield.dart';
import 'package:damdiet/core/theme/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/bottom_cta_button.dart';
import '../../../core/widgets/damdiet_appbar.dart';
import '../../../data/repositories/nutrition_repository.dart';

class KcalCalculatorScreenWrapper extends StatelessWidget {
  const KcalCalculatorScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<NutritionRepository>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => KcalCalculatorViewmodel(repo),
      child: const KcalCalculatorScreen(),
    );
  }
}

class KcalCalculatorScreen extends StatefulWidget {
  const KcalCalculatorScreen({super.key});

  @override
  State<KcalCalculatorScreen> createState() => _KcalCalculatorScreenState();
}

class _KcalCalculatorScreenState extends State<KcalCalculatorScreen> {
  var productTextController = TextEditingController();
  var companyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<KcalCalculatorViewmodel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DamdietAppbar(title: '칼로리계산기', showBackButton: false),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              CustomTextField(
                                hintText: '음식 명',
                                controller: productTextController,
                              ),
                              SizedBox(height: 8),
                              CustomTextField(
                                hintText: '제조사 명',
                                controller: companyTextController,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 14),
                        IconButton(
                          onPressed: () {
                            viewModel.searchFood(
                              productTextController.text,
                              companyTextController.text,
                            );
                            FocusScope.of(context).unfocus();
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/ic_search_fill.svg',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(thickness: 6, color: AppColors.gray100),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '검색결과',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'PretendardSemiBold',
                            color: AppColors.textMain,
                          ),
                        ),
                        Visibility(
                          visible: viewModel.isSearching,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 260,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return KcalListviewItem(
                            index: index,
                            viewModel: viewModel,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(thickness: 1, color: AppColors.textSub),
                        itemCount: viewModel.searchedFoodList.length,
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                    Divider(thickness: 6, color: AppColors.gray100),
                    Text(
                      '칼로리계산',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'PretendardSemiBold',
                        color: AppColors.textMain,
                      ),
                    ),
                    Divider(thickness: 1, color: AppColors.textSub),
                    KcalCheckedList(),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UnderlineText(
                      text: '계산된 칼로리 양은 ${viewModel.selectedCalSum} kcal 입니다.',
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'PretendardSemiBold',
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
