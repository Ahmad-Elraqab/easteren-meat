import 'package:drivers/AppLocalization.dart';
import 'package:drivers/constants/colors.dart';
import 'package:drivers/constants/constants.dart';
import 'package:drivers/models/responses/order/OrderModel.dart';
import 'package:drivers/provider/GeneralProvider.dart';
import 'package:drivers/singleton/dio.dart';
import 'package:drivers/views/alert_dialogs/ChangeOrderStateDialog.dart';
import 'package:drivers/views/map/selectFromMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  OrderModel orderModel;
  bool fromPrev;

  OrderDetails({Key key, this.orderModel, this.fromPrev = false}) : super(key: key);

  @override
  _OrderDetails createState() => _OrderDetails();
}

class _OrderDetails extends State<OrderDetails> {
  Widget appBarTitle;
  Icon backIcon = Icon(Icons.arrow_back_ios, color: white);
  int count = 1;

  String date;

  @override
  Widget build(BuildContext context) {
    appBarTitle =
        Text(getTranslated(context, 'Order_Details'), style: appBarTitleStyle);

    return SafeArea(
        child: Scaffold(
      appBar: buildBar(),
      backgroundColor: offwhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 100.h),
            Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                contentListView(),
                Container(
                  child: Image.asset("assets/images/logo.png",
                      width: 360.w, height: 360.w),
                ),
              ],
            ),
//            printWidget(),
            !widget.fromPrev? myButton(): Container(),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    ));
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

  Widget contentListView() {
    return Container(
      margin: EdgeInsetsDirectional.only(
          top: 170.h, end: 42.w, start: 42.w, bottom: 30.h),
      padding: EdgeInsetsDirectional.only(top: 200.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: white,
          boxShadow: [
            BoxShadow(
                color: black.withOpacity(.16),
                offset: Offset(0, 0),
                blurRadius: 10,
                spreadRadius: 1)
          ]),
      child: Column(
        children: <Widget>[
          Text(widget.orderModel.invoice.user,
              textAlign: TextAlign.center,
              style: (TextStyle(
                  fontFamily: NEO_SANS_FONT_FAMILY,
                  color: primaryColor,
                  fontSize: 42.ssp,
                  fontWeight: FontWeight.bold))),
          SizedBox(height: 42.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  onTap: () async {
//                    print("user mobile = "+widget.orderModel.invoice.userMobile);
                    if (await canLaunch(
                        'tel:${widget.orderModel.invoice.userMobile}')) {
                      await launch(
                          'tel:${widget.orderModel.invoice.userMobile}');
                    } else {
                      showErrorString(
                          context, getTranslated(context, "couldNotCallPhone"));
                    }
                  },
                  child: SvgPicture.asset('assets/images/call.svg')),
              SizedBox(width: 30.w),
              GestureDetector(
                  onTap: () async{
                    /* => showPlacePicker()*/
                    String googleUrl = 'https://www.google.com/maps/search/?api=1&query='+
                        widget.orderModel.invoice.shipping.lat.toString()+
                        ','+widget.orderModel.invoice.shipping.lng.toString();
                    if (await canLaunch(googleUrl)) {
                    await launch(googleUrl);
                    } else {
                      showErrorString(context, getTranslated(context, "Could not open the map"));
                    }
                  },
                  child: SvgPicture.asset('assets/images/gps.svg')),
            ],
          ),
          SizedBox(height: 30.h),
          recivedRow(getTranslated(context, 'Order_Num'),
              '# ' + widget.orderModel.orderNumber),
          recivedRow(
              getTranslated(context, 'Total_Order'),
              widget.orderModel.invoice.amount.toString() +
                  " " +
                  getTranslated(context, "sr")),
          recivedRow(getTranslated(context, 'Order_Date'),
              widget.orderModel.createdAt.split(" ")[0]),
          recivedRow(getTranslated(context, 'Delivery_Date'),
              widget.orderModel.deliverDay),
          SizedBox(height: 100.h),
          ListView.builder(

              ///from api
              itemCount: widget.orderModel.orderProducts.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                /*if (index == 2) // last item don't put separator below
                  return content(1);*/
                return content(index, widget.orderModel.orderProducts.length,
                    widget.orderModel.orderProducts[index]);
              }),
          SizedBox(
            height: 50.h,
          )
        ],
      ),
    );
  }

  Widget content(int i, int length, OrderProducts orderProduct) {
    return Column(
      children: <Widget>[
        billCard(orderProduct),
        i + 1 != length ? separtor() : Container()
      ],
    );
  }

  Widget recivedRow(perStr, varStr) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      margin: EdgeInsetsDirectional.only(top: 42.h),
      child: Row(
        children: <Widget>[
          Container(
            width: 300.w,
            alignment: AlignmentDirectional.topStart,
            margin: EdgeInsetsDirectional.only(start: 42.w),
            child: Text(perStr,
                textAlign: TextAlign.start,
                style: (TextStyle(
                    fontFamily: NEO_SANS_FONT_FAMILY,
                    color: blackline,
                    fontSize: 39.ssp))),
          ),
          SizedBox(width: 72.w),
          Row(
            children: <Widget>[
              Container(
                alignment: AlignmentDirectional.topStart,
                child: Text(varStr,
                    textAlign: TextAlign.center,
                    style: (TextStyle(
                        fontFamily: NEO_SANS_FONT_FAMILY,
                        color: (perStr == getTranslated(context, 'Order_Num'))
                            ? primaryColor
                            : blackline,
                        fontSize: 39.ssp))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget billCard(OrderProducts orderProduct) {
    return Container(
      height: 220.h,
      margin: EdgeInsetsDirectional.only(top: 20.h, start: 25.w),
      child: Center(
        child: Wrap(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 1.4 / 7,
              height: MediaQuery.of(context).size.width * 1.4 / 7,
              margin: EdgeInsetsDirectional.only(start: 14.h),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(orderProduct.product.cover),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  color: white),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1.1 / 3,
              margin: EdgeInsetsDirectional.only(start: 25.w),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 1.1 / 3,
                    margin: EdgeInsetsDirectional.only(top: 40.sp),
                    child: Text(orderProduct.product.name,
                        textAlign: TextAlign.start,
                        style: (TextStyle(
                            fontFamily: NEO_SANS_FONT_FAMILY,
                            color: blackline,
                            fontSize: 36.ssp))),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1.1 / 3,
                    margin: EdgeInsetsDirectional.only(top: 30.sp),
                    child: Text(
                        getTranslated(context, 'Order_Num') +
                            " " +
                            orderProduct.quantity.toString(),
                        textAlign: TextAlign.start,
                        style: (TextStyle(
                            fontFamily: NEO_SANS_FONT_FAMILY,
                            color: blackline,
                            fontSize: 36.ssp))),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1.4 / 7,
              margin: EdgeInsetsDirectional.only(top: 38.sp),
              alignment: AlignmentDirectional.topEnd,
              child: Text(
                  orderProduct.amount.toString() +
                      " " +
                      getTranslated(context, "sr"),
                  textAlign: TextAlign.start,
                  style: (TextStyle(
                      fontFamily: NEO_SANS_FONT_FAMILY,
                      color: primaryColor,
                      fontSize: 39.ssp))),
            )
          ],
        ),
      ),
    );
  }

  Widget printWidget() {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 14.h, end: 50.w, bottom: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SvgPicture.asset("assets/images/print.svg"),
          SizedBox(width: 15.w),
          Text(getTranslated(context, 'Print'),
              textAlign: TextAlign.start,
              style: (TextStyle(
                fontFamily: NEO_SANS_FONT_FAMILY,
                color: gray,
                fontSize: 39.ssp,
              ))),
        ],
      ),
    );
  }

  Widget separtor() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = boxWidth.ceil();
        return Container(
          height: 50.h,
          child: Wrap(
            children: List.generate(dashCount, (_) {
              return Text(
                ".",
                style: TextStyle(color: lightgray),
              );
            }),
          ),
        );
      },
    );
  }

  Widget myButton() {
    return Center(
      child: Container(
        height: 170.h,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsetsDirectional.only(end: 85.w, start: 85.w, top: 25.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.w), color: primaryColor),
        child: FlatButton(
          child: Text(getTranslated(context, 'Change_Order_Status'),
              textAlign: TextAlign.center,
              style: (TextStyle(
                fontFamily: NEO_SANS_FONT_FAMILY,
                color: white,
                fontSize: 48.ssp,
              ))),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => ChangeNotifierProvider(
                      child: ChangeOrderStateDialog(
                        orderId: widget.orderModel.id,
                          shippingId: widget.orderModel.invoice.shipping.id
                      ),
                      create: (context) => GeneralProvider(),
                    ));
            /*Navigator.push(context, MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  child:  ChangeOrderStateDialog(orderId: widget.orderModel.id,),
                  create: (context) => GeneralProvider(),
                )
            ));*/
          },
        ),
      ),
    );
  }

  showPlacePicker() async {
    await Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => MapsDemo(
              selectFromMap: (lat, lng, address) {
                print("CallBack  $lat , $lng  , $address");

                final coordinates = new Coordinates(lat, lng);

                Geocoder.local
                    .findAddressesFromCoordinates(coordinates)
                    .then((addresses) {
                  if (addresses.length > 0) {
                    setState(() {
//                  addressMap = addresses.first.addressLine;
                    });
                  }
                });
              },
            )));
  }
}
