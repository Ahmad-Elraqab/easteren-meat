import 'package:drivers/AppLocalization.dart';
import 'package:drivers/constants/colors.dart';
import 'package:drivers/constants/constants.dart';
import 'package:drivers/constants/routes.dart';
import 'package:drivers/models/classes/OrderStatus.dart';
import 'package:drivers/models/classes/PayTypes.dart';
import 'package:drivers/models/responses/periods/PeriodModel.dart';
import 'package:drivers/provider/GeneralProvider.dart';
import 'package:drivers/singleton/dio.dart';
import 'package:drivers/views/alert_dialogs/MyAlertDialog.dart';
import 'package:drivers/views/bank_accounts/BankAccounts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ChangeOrderStateDialog extends StatefulWidget {
  int orderId;
  int shippingId;
  ChangeOrderStateDialog({this.orderId, this.shippingId});

  @override
  _ChangeOrderStateDialog createState() => _ChangeOrderStateDialog();
}

class _ChangeOrderStateDialog extends State<ChangeOrderStateDialog> {
  List<OrderStatus> orderStates = List<OrderStatus>();
  OrderStatus orderState;
  DateTime selectedDateValue = DateTime.now();
  DateTime selectedDate = DateTime.now();
  List<PayTypes> paymentMethods = List<PayTypes>();
  PayTypes paymentMethod;
  List<PeriodModel> periodsList = List<PeriodModel>();
  PeriodModel deliveryTime;
  String choicePeriodValue;

  TextEditingController reasonController = TextEditingController();
  String choiceDate;
  bool viewReason = false;
  bool viewDate = false;
  bool viewPayment = false;
  bool viewPeriod = false;
  bool checkData = true;
  final _formKey = GlobalKey<FormState>();

  TextStyle stylee =
      TextStyle(fontFamily: SST_FONT_FAMILY, color: gray0, fontSize: 48.ssp);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewReason = false;
    viewDate = false;
    viewPayment = false;
    viewPeriod = false;

    periodsList.add(PeriodModel(
        id: 0, startDeliveryTime: "", endDeliveryTime: "", ordersCount: 0));
  }

  @override
  Widget build(BuildContext context) {
    initt();
    return Container(
      margin: EdgeInsetsDirectional.only(start: 50.w, end: 50.w),
      alignment: AlignmentDirectional.center,
      child: Material(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.5 / 3,
          color: white,
          padding: EdgeInsetsDirectional.only(start: 50.w, end: 50.w),
          child: ListView(
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 100.h),
                    label(context, getTranslated(context, 'Order_Status')),
                    SizedBox(height: 20.h),
                    container(0),
                    reasonContainer(),
                    containerDate(),
                    SizedBox(height: 70.h),
                    containerDeliveryTime(),
                    SizedBox(height: 20.h),
                    viewPayment
                        ? label(
                            context, getTranslated(context, 'Payment_Method'))
                        : Container(),
                    SizedBox(height: 20.h),
                    container(1)
                  ],
                ),
              ),
              SizedBox(height: 50.h),
              myButton(),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget label(BuildContext context, String str) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      margin: EdgeInsetsDirectional.only(start: 10.w, bottom: 20.h),
      child: Text(str,
          style: TextStyle(
            color: gray0,
            fontFamily: NEO_SANS_FONT_FAMILY,
            fontSize: 51.ssp,
          )),
    );
  }

  Widget myButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(24.w), color: red),
      child: FlatButton(
        padding: EdgeInsets.all(30.w),
        child: Text(getTranslated(context, 'End'),
            textAlign: TextAlign.center,
            style: (TextStyle(
              fontFamily: SST_FONT_FAMILY,
              color: white,
              fontSize: 46.ssp,
            ))),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            print("_formKey.currentState.validate()" + viewPayment.toString());
            if (orderState.statusId == 5) {
              Map<String, dynamic> data = {
                "status": orderState.statusId.toString(),
                "pay_type": paymentMethod.payId.toString(),
                "bank_id": "",
                "deliver_day": "",
                "deliver_time_id": "",
                "cancel_reason": "",
              };
              if (viewPayment && paymentMethod.payId == 2 || paymentMethod.payId == 3) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            ChangeNotifierProvider(
                              child: BankAccounts(
                                data: data,
                                orderId: widget.orderId,
                                statusName: orderState.statusName,
                              ),
                              create: (context) => GeneralProvider(),
                            )));
              } else if (viewPayment && paymentMethod.payId == 0) {
                showErrorString(context,
                    getTranslated(context, "Payment method must be chosen"));
              } else {
                Provider.of<GeneralProvider>(context, listen: false)
                    .changeOrderStatus(context, widget.orderId, data, () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (_) =>
                          MyAlertDialog(0, orderState.statusName));
                });
              }
            } else if(orderState.statusId == 6){
              Map<String, dynamic> data = {
                "status": orderState.statusId.toString(),
                "pay_type": "",
                "bank_id": "",
                "deliver_day": "",
                "deliver_time_id": "",
                "cancel_reason": orderState.statusId == 6
                    ? reasonController.text.toString()
                    : "",
              };
              Provider.of<GeneralProvider>(context, listen: false)
                  .changeOrderStatus(context, widget.orderId, data, () {
                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (_) =>
                        MyAlertDialog(0, orderState.statusName));
              });
            } else if(orderState.statusId == 7){
              print("_formKey.currentState.validate() >> else");
              if (deliveryTime != null) {
                if (deliveryTime.id > 0) {
                  Map<String, dynamic> data = {
                    "status": orderState.statusId.toString(),
                    "pay_type": "",
                    "bank_id": "",
                    "deliver_day":
                    selectedDateValue.toString().split(" ")[0] ?? "",
                    "deliver_time_id":
                    deliveryTime != null ? deliveryTime.id.toString() : "",
                    "cancel_reason": "",
                  };
                  Provider.of<GeneralProvider>(context, listen: false)
                      .changeOrderStatus(context, widget.orderId, data, () {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (_) =>
                            MyAlertDialog(0, orderState.statusName));
                  });
                } else {
                  showErrorString(
                      context, getTranslated(context, "Can't order today"));
                }
              }
            }
          }else {
              print("!!!_formKey.currentState.validate()");
            }

        },
      ),
    );
  }

  Widget container(int i) {
    return Visibility(
      visible: i == 1 ? viewPayment : i == 2 ? viewPeriod : true,
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsetsDirectional.only(start: 30.w, end: 30.w),
            decoration: BoxDecoration(
                border: Border.all(color: offwhite0, width: 3.w),
                borderRadius: BorderRadius.circular(20.h),
                color: white),
            child: i == 0
                ? dropDownListOrderStatus()
                : i == 1 ? dropDownListPayTypes() : dropDownListDeliveryTimes(),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(end: 40.w),
            child: SvgPicture.asset(
              'assets/images/arrow.svg',
              color: lightgray,
            ),
          )
        ],
      ),
    );
  }

  Widget containerDeliveryTime() {
    return Visibility(
      visible: viewPeriod,
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsetsDirectional.only(start: 30.w, end: 30.w),
            decoration: BoxDecoration(
                border: Border.all(color: offwhite0, width: 3.w),
                borderRadius: BorderRadius.circular(20.h),
                color: white),
            child: dropDownListDeliveryTimes(),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(end: 40.w),
            child: SvgPicture.asset(
              'assets/images/arrow.svg',
              color: lightgray,
            ),
          )
        ],
      ),
    );
  }

  Widget containerDate() {
    return Visibility(
      visible: viewDate,
      child: InkWell(
        onTap: () {
          _selectDate(context);
        },
        child: Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: <Widget>[
            Container(
              margin: EdgeInsetsDirectional.only(top: 80.sp),
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsetsDirectional.only(start: 30.w, end: 30.w),
              decoration: BoxDecoration(
                  border: Border.all(color: offwhite0, width: 3.w),
                  borderRadius: BorderRadius.circular(20.h),
                  color: white),
              child: Padding(
                padding: EdgeInsetsDirectional.only(top: 40.sp),
                child: Text(
                  selectedDateValue.toString().split(" ")[0],
                  style: TextStyle(
                    fontSize: 42.ssp,
                    fontFamily: NEO_SANS_FONT_FAMILY,
                    color: gray0,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsetsDirectional.only(top: 80.sp, end: 40.w),
              child: SvgPicture.asset(
                'assets/images/arrow.svg',
                color: lightgray,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dropDownListOrderStatus() {
    return DropdownButton<OrderStatus>(
        hint: Padding(
          padding: EdgeInsetsDirectional.only(end: 80.sp),
          child: Text(
            getTranslated(context, "choice"),
            style: TextStyle(
                color: gray0,
                fontFamily: NEO_SANS_FONT_FAMILY,
                fontSize: 35.ssp),
          ),
        ),
        value: orderState != null ? orderState : orderState,
        icon: SizedBox(),
        underline: SizedBox(),
        onChanged: (newValue) {
          setState(() {
            orderState = newValue;
            if (newValue.statusId == 5) {
              viewReason = false;
              viewPayment = true;
              viewDate = false;
              viewPeriod = false;
              if (paymentMethods != null) {
                paymentMethods.clear();
                paymentMethods
                    .add(PayTypes(0, getTranslated(context, 'choice')));
                paymentMethods.add(PayTypes(1, getTranslated(context, 'COD')));
                paymentMethods.add(PayTypes(2, getTranslated(context, 'Bank')));
                paymentMethods
                    .add(PayTypes(3, getTranslated(context, 'Network')));
                paymentMethods
                    .add(PayTypes(4, getTranslated(context, 'Deferred')));
                paymentMethod = paymentMethods[0];
              }
            }
            if (newValue.statusId == 6) {
              viewReason = true;
              viewPayment = false;
              viewDate = false;
              viewPeriod = false;
              paymentMethods.clear();
              paymentMethods.add(PayTypes(0, getTranslated(context, 'choice')));
              paymentMethod = paymentMethods[0];
            }
            if (newValue.statusId == 7) {
              viewReason = false;
              viewPayment = false;
              viewDate = true;
              paymentMethods.clear();
              paymentMethods.add(PayTypes(0, getTranslated(context, 'choice')));
              paymentMethod = paymentMethods[0];
              Provider.of<GeneralProvider>(context, listen: false).getPeriods(
                  context, widget.shippingId, selectedDateValue.toString().split(" ")[0], () {
                print("get periods successfully");
//                if(periodsList!=null) periodsList.clear();
                setState(() {
                  selectedDate = DateTime.now();
                  periodsList.clear();
                  periodsList.add(PeriodModel(
                      id: 0,
                      startDeliveryTime: "",
                      endDeliveryTime: "",
                      ordersCount: 0));
                  for (int i = 0;
                      i <
                          Provider.of<GeneralProvider>(context, listen: false)
                              .periodsList
                              .length;
                      i++) {
                    periodsList.add(PeriodModel(
                        id: Provider.of<GeneralProvider>(context, listen: false)
                            .periodsList[i]
                            .id,
                        startDeliveryTime:
                            Provider.of<GeneralProvider>(context, listen: false)
                                .periodsList[i]
                                .startDeliveryTime,
                        endDeliveryTime:
                            Provider.of<GeneralProvider>(context, listen: false)
                                .periodsList[i]
                                .endDeliveryTime,
                        ordersCount:
                            Provider.of<GeneralProvider>(context, listen: false)
                                .periodsList[i]
                                .ordersCount));
                  }
                  if (periodsList.length > 0) {
                    print("periodsList length = " +
                        periodsList.length.toString());
                    deliveryTime = periodsList[0];
//                    choicePeriodValue = periodsList[0].getPeriod(context);
//            periodId = periodsList[0].id;
                    viewPeriod = true;
                  } else {
//            choicePeriod = "";
                    choicePeriodValue = "";
                    viewPeriod = false;
                  }
                });
              });
            }
          });
        },
        items: orderStates.map((OrderStatus value) {
          return DropdownMenuItem<OrderStatus>(
            value: value,
            child: Text(
              value.statusName,
              style: (stylee),
            ),
          );
        }).toList());
  }

  Widget dropDownListPayTypes() {
    return DropdownButton<PayTypes>(
        hint: Padding(
          padding: EdgeInsetsDirectional.only(end: 80.sp),
          child: Text(
            getTranslated(context, "choice"),
            style: TextStyle(
                color: gray0,
                fontFamily: NEO_SANS_FONT_FAMILY,
                fontSize: 35.ssp),
          ),
        ),
        value: paymentMethod != null ? paymentMethod : null,
        icon: SizedBox(),
        underline: SizedBox(),
        onChanged: (newValue) {
          setState(() {
            paymentMethod = newValue;
          });
        },
        items: paymentMethods.map<DropdownMenuItem<PayTypes>>((PayTypes value) {
          return DropdownMenuItem<PayTypes>(
            value: value,
            child: Text(
              value.payName,
              style: (stylee),
            ),
          );
        }).toList());
  }

  Widget dropDownListDeliveryTimes() {
    return DropdownButton<PeriodModel>(
        hint: Padding(
          padding: EdgeInsetsDirectional.only(end: 80.sp),
          child: Text(
            getTranslated(context, "Choice delivery time"),
            style: TextStyle(
                color: gray0,
                fontFamily: NEO_SANS_FONT_FAMILY,
                fontSize: 35.ssp),
          ),
        ),
        value: deliveryTime != null ? deliveryTime : deliveryTime,
        icon: SizedBox(),
        underline: SizedBox(),
        onChanged: (newValue) {
          setState(() {
            deliveryTime = newValue;
          });
        },
        items:
            periodsList.map<DropdownMenuItem<PeriodModel>>((PeriodModel value) {
          return DropdownMenuItem<PeriodModel>(
            value: value,
            child: Text(
              value.id == 0
                  ? getTranslated(context, "Choice delivery time")
                  : value.getPeriod(context),
              style: (stylee),
            ),
          );
        }).toList());
  }

  void initt() {
    choiceDate = getTranslated(context, "choiceDeliveryDate");
    if (checkData) {
      checkData = false;
      if (orderStates != null) {
        orderStates.add(OrderStatus(5, getTranslated(context, 'Completed')));
        orderStates.add(OrderStatus(6, getTranslated(context, 'Canceled')));
        orderStates
            .add(OrderStatus(7, getTranslated(context, 'DeferredStatus')));
      }

      if (paymentMethods != null) {
        paymentMethods.clear();
        paymentMethods.add(PayTypes(0, getTranslated(context, 'choice')));
        paymentMethods.add(PayTypes(1, getTranslated(context, 'COD')));
        paymentMethods.add(PayTypes(2, getTranslated(context, 'Bank')));
        paymentMethods.add(PayTypes(3, getTranslated(context, 'Network')));
        paymentMethods.add(PayTypes(4, getTranslated(context, 'Deferred')));
      }
    }
    /*orderState = orderStates[0];

    paymentMethod = paymentMethods[0];*/
  }

  Widget reasonContainer() {
    return Visibility(
      visible: viewReason,
      child: Container(
        margin: EdgeInsetsDirectional.only(top: 80.sp),
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: offwhite0, width: 3.w),
          borderRadius: BorderRadius.all(Radius.circular(20.h)),
          /*boxShadow: [
            BoxShadow(
                color: darkblue.withOpacity(.1),
                offset: Offset(0, 0),
                blurRadius: 10,
                spreadRadius: 0)
          ],*/
          color: white,
        ),
        child: address(),
      ),
    );
  }

  Widget address() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return getTranslated(context, 'Please_Enter_Required');
        }
        return null;
      },
      cursorColor: primaryColor,
      controller: reasonController,
      textAlign: TextAlign.start,
      maxLines: 12,
      style: TextStyle(
          color: primaryColor,
          fontFamily: NEO_SANS_FONT_FAMILY,
          fontSize: 42.ssp),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          filled: true,
          fillColor: white,
          hintText: getTranslated(context, "reason"),
          hintStyle: TextStyle(
              color: gray0, fontFamily: NEO_SANS_FONT_FAMILY, fontSize: 42.ssp),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: red, width: 3.w),
              borderRadius: BorderRadius.all(Radius.circular(20.h))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: red, width: 3.w),
              borderRadius: BorderRadius.all(Radius.circular(20.h)))),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2101));
    int diffDay = picked.difference(selectedDate).inDays;
    if (picked != null && (picked.isAfter(selectedDate) || diffDay == 0)) {
      setState(() {
        selectedDate = picked;
        selectedDateValue = picked;
        print("selectedDate = " + selectedDate.toString().split(" ")[0]);
      });
      Provider.of<GeneralProvider>(context, listen: false)
          .getPeriods(context, widget.shippingId, selectedDate.toString().split(" ")[0], () {
        print("get periods successfully");

        setState(() {
          selectedDate = DateTime.now();
          periodsList.clear();
          periodsList.add(PeriodModel(
              id: 0,
              startDeliveryTime: "",
              endDeliveryTime: "",
              ordersCount: 0));
          for (int i = 0; i < Provider.of<GeneralProvider>(context, listen: false).periodsList.length; i++) {
            periodsList.add(PeriodModel(
                id: Provider.of<GeneralProvider>(context, listen: false)
                    .periodsList[i]
                    .id,
                startDeliveryTime:
                    Provider.of<GeneralProvider>(context, listen: false)
                        .periodsList[i]
                        .startDeliveryTime,
                endDeliveryTime:
                    Provider.of<GeneralProvider>(context, listen: false)
                        .periodsList[i]
                        .endDeliveryTime,
                ordersCount:
                    Provider.of<GeneralProvider>(context, listen: false)
                        .periodsList[i]
                        .ordersCount));
          }
          if (periodsList.length > 0) {
            print("periodsList length = " + periodsList.length.toString());
            deliveryTime = periodsList[0];
//            choicePeriodValue = periodsList[0].getPeriod(context);
//            periodId = periodsList[0].id;
            viewPeriod = true;
          } else {
//            choicePeriod = "";
            choicePeriodValue = "";
            viewPeriod = false;
          }
        });
      });
    } else {
      selectedDate = DateTime.now();
      print("picked.day = " +
          picked.day.toString() +
          "|| selectedDate.day = " +
          selectedDate.day.toString());
      showErrorString(
          context, getTranslated(context, "anOldDateCannotBeChosen"));
    }
  }
}
