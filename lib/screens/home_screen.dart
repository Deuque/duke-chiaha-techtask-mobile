import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tech_task/routes.dart';
import 'package:tech_task/widgets/custom_datepicker.dart';

class HomeScreenKeys {
  static const getIngredientsButton = Key('getIngredientsButton');
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    final curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.decelerate);
    _scaleAnimation =
        Tween<double>(begin: 200, end: 120).animate(curvedAnimation);
    _positionAnimation =
        Tween<Offset>(begin: Offset(0.0, 0.5), end: Offset(0, 0)).animate(
      curvedAnimation,
    );

    Future.delayed(
      Duration(milliseconds: 900),
      () => _animationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, value) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SlideTransition(
                            position: _positionAnimation,
                            child: SvgPicture.asset(
                              'assets/images/cooking.svg',
                              height: _scaleAnimation.value,
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: _animationController.isCompleted ? 1 : 0,
                            curve: Curves.decelerate,
                            duration: const Duration(milliseconds: 400),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 40),
                                CustomDateField(
                                  label: 'Select a lunch date',
                                  firstDate: DateTime(2000),
                                  initialDate: _selectedDate,
                                  dateFormat: DateFormat('dd MMM, yyyy'),
                                  onDateSelected: (date) =>
                                      _selectedDate = date,
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                  key: HomeScreenKeys.getIngredientsButton,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.ingredients,
                                      arguments: _selectedDate,
                                    );
                                  },
                                  child: Text('Get Ingredients'),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
