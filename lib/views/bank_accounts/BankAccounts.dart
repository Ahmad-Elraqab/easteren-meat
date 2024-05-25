import 'package:drivers/AppLocalization.dart';
import 'package:drivers/constants/colors.dart';
import 'package:drivers/constants/constants.dart';
import 'package:drivers/models/responses/bank/BankModel.dart';
import 'package:drivers/provider/GeneralProvider.dart';
import 'package:drivers/views/alert_dialogs/MyAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class BankAccounts extends StatefulWidget {
  Map<String, dynamic> data;
  int orderId;
  String statusName;

  BankAccounts({this.data, this.orderId, this.statusName});

  @override
  _BankAccounts createState() => _BankAccounts();
}

class _BankAccounts extends State<BankAccounts> {
  List<bool> isPressComp = [true, false];
  Widget appBarTitle;
  Icon backIcon = Icon(Icons.arrow_back_ios, color: white);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<GeneralProvider>(context, listen: false).getBanks(context, () {
      print("get banks successfully");
    });
  }

  @override
  Widget build(BuildContext context) {
    appBarTitle =
        Text(getTranslated(context, 'Bank_Accounts'), style: appBarTitleStyle);

    return SafeArea(
      child: Scaffold(
          appBar: buildBar(),
          backgroundColor: offwhite,
          body: Consumer<GeneralProvider>(
              builder: (context, generalProvider, child) {
            return generalProvider.bankList.length > 0
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 80.h),
                        widget.data != null
                            ? Padding(
                          padding: EdgeInsetsDirectional.only(start: 40.sp, end: 40.sp, bottom: 40.sp),
                            child: Text(
                                getTranslated(
                                    context, "Choose the bank account"),
                                style: TextStyle(
                                  fontFamily: NEO_SANS_FONT_FAMILY,
                                  fontSize: 60.ssp,
                                  color: darkblack,
                                ),
                              )
                        )
                            : Container(),
                        companiesListView(generalProvider.bankList),
                      ],
                    ),
                  )
                : Center(
                    child: Container(
                      width: 100.w,
                      height: 100.h,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballScaleRippleMultiple,
                        color: primaryColor,
                      ),
                    ),
                  );
          })),
    );
  }

  Widget buildBar() {
    return new AppBar(
        elevation: 0,
        centerTitle: true,
        title: appBarTitle,
        backgroundColor: primaryColor,
        leading: IconButton(
            icon: backIcon,
            onPressed: () {
              Navigator.pop(context);
            }));
  }

  Widget companyContainer(BankModel bankModel) {
    return InkWell(
      onTap: () {
        if (widget.data != null) {
          widget.data["bank_id"] = bankModel.id.toString();
          Provider.of<GeneralProvider>(context, listen: false)
              .changeOrderStatus(context, widget.orderId, widget.data, () {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (_) => MyAlertDialog(0, widget.statusName));
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin:
            EdgeInsetsDirectional.only(end: 45.w, start: 45.w, bottom: 60.h),
        padding: EdgeInsets.all(36.w),
        height: 600.h,
        color: white,
        child: Column(
          children: <Widget>[
            companyImage(bankModel.icon),
            SizedBox(height: 60.h),
            companyInfo(getTranslated(context, 'Account_Name'), bankModel.name),
            SizedBox(height: 30.h),
            companyInfo(
                getTranslated(context, 'Account_Num'), bankModel.accountNumber),
            SizedBox(height: 30.h),
            companyInfo(getTranslated(context, 'IBAN'), bankModel.iBan),
          ],
        ),
      ),
    );
  }

  Widget companyInfo(perStr, varStr) {
    return Row(
      children: <Widget>[
        Container(
          alignment: AlignmentDirectional.topStart,
          child: Text(perStr,
              textAlign: TextAlign.start,
              style: (TextStyle(
                  fontFamily: NEO_SANS_FONT_FAMILY,
                  color: darkblack,
                  fontSize: 39.ssp))),
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsetsDirectional.only(start: 10.sp),
              alignment: AlignmentDirectional.topStart,
              child: Text(varStr,
                  textAlign: TextAlign.center,
                  style: (TextStyle(
                      fontFamily: NEO_SANS_FONT_FAMILY,
                      color: gray0,
                      fontSize: 39.ssp))),
            ),
          ],
        ),
      ],
    );
  }

  Widget companyImage(String image) {
    return Container(
        alignment: AlignmentDirectional.center,
        width: 450.w,
        height: 150.h,
        child: Image.network(image, fit: BoxFit.fitWidth, loadingBuilder:
            (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        }));
  }

  Widget companiesListView(List<BankModel> bankList) {
    return bankList != null
        ? ListView.builder(
            itemCount: bankList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return companyContainer(bankList[index]);
            },
          )
        : Container();
  }
}
