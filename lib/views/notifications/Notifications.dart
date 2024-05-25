import 'package:drivers/AppLocalization.dart';
import 'package:drivers/constants/colors.dart';
import 'package:drivers/constants/constants.dart';
import 'package:drivers/models/responses/notification/NotificationModel.dart';
import 'package:drivers/provider/GeneralProvider.dart';
import 'package:drivers/views/orders/OrderDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Notifications extends StatefulWidget {
  @override
  _Notifications createState() => _Notifications();
}

class _Notifications extends State<Notifications> {
  Widget appBarTitle;
  //pagination
  RefreshController refreshController =
  RefreshController(initialRefresh: false);
  bool isLoading = false;
  var nextPage = 2;
  var lastPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<GeneralProvider>(context, listen: false)
        .getNotifications(context, 1, () {
      lastPage = Provider.of<GeneralProvider>(context, listen: false).lastPage;
    });

  }

  @override
  Widget build(BuildContext context) {
    appBarTitle = Text(getTranslated(context, 'Notifications'),
        style: appBarTitleStyle);
    return SafeArea(
        child: Scaffold(
            appBar: buildBar(),
            backgroundColor: offwhite,
            body: notificationList()));
  }

  Widget buildBar() {
    return AppBar(
        elevation: 0,
        centerTitle: true,
        title: appBarTitle,
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor);
  }

  Widget notificationList() {
    return Consumer<GeneralProvider>(
      builder: (context, generalProvider, child) {
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("");
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("");
              } else {
                body = Text(getTranslated(context, "noMoreData"));
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: refreshController,
          onRefresh: onRefresh,
          onLoading: onLoading,
          child: Provider.of<GeneralProvider>(context, listen: false).isLoading?
            generalProvider.notificationsList.length > 0
              ? ListView.builder(
              shrinkWrap: true,
              itemCount: generalProvider.notificationsList != null
                  ? generalProvider.notificationsList.length
                  : 0,
              itemBuilder: (BuildContext context, int index) {
                return notifContainer(
                    generalProvider.notificationsList != null
                        ? generalProvider
                        .notificationsList[index]
                        : null
                );
              }): Center(
            child: Padding(
              padding: EdgeInsets.only(top: 0.sp),
              child: Text(
                getTranslated(context, "thereCurrentlyNoContent"),
                style: TextStyle(
                  fontFamily: NEO_SANS_FONT_FAMILY,
                  fontSize: 40.ssp,
                  color: gray00,
                ),
              ),
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
          ),
        );
      }
    );
  }

  Widget notifContainer(NotificationModel notificationModel) {
    return InkWell(
      onTap: (){
        print("notificationModel.orderModel.status = "+notificationModel.orderModel.status.toString());
        if(notificationModel.orderModel != null)
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                child: OrderDetails(orderModel: notificationModel.orderModel,
                    fromPrev: notificationModel.orderModel.status == 5? true: false),
                create: (context) => GeneralProvider(),
              )
          ));
      },
      child: Container(
          margin: EdgeInsetsDirectional.only(top: 30.h, bottom: 20.h),
          padding: EdgeInsetsDirectional.only(start: 30.w),
          height: 270.h,
          color: white,
          child: Row(
            children: <Widget>[
              convImage(notificationModel),
              texts(notificationModel),
              time(notificationModel)],
          )),
    );
  }

  Widget convImage(NotificationModel notificationModel) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          Container(
            margin: EdgeInsetsDirectional.only(end: 30.w),
            child: Image.asset("assets/images/logo.png", width: 200.w, height: 200.h,),
          ),
        ],
      ),
    );
  }

  Widget texts(NotificationModel notificationModel) {
    return Container(
      width: MediaQuery.of(context).size.width * 1.2 / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: AlignmentDirectional.centerStart,
            child: Text(notificationModel.title,
                textAlign: TextAlign.start,
                style: (TextStyle(
                  fontFamily: SST_FONT_FAMILY,
                  fontWeight: FontWeight.w300,
                  color: blackgray,
                  fontSize: 39.ssp,
                ))),
          ),
          Container(
            alignment: AlignmentDirectional.centerStart,
            child: Text(notificationModel.details,
                textAlign: TextAlign.start,
                style: (TextStyle(
                  fontFamily: SST_FONT_FAMILY,
                  color: graydetails,
                  fontSize: 30.ssp,
                ))),
          )
        ],
      ),
    );
  }

  Widget time(NotificationModel notificationModel) {
    return Container(
      child: Text(notificationModel.createdAt.split(" ")[1],
          textAlign: TextAlign.start,
          style: (TextStyle(
            fontFamily: SST_FONT_FAMILY,
            color: graydetails,
            fontSize: 30.ssp,
          ))),
    );
  }

  void onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    if (Provider.of<GeneralProvider>(context, listen: false)
        .notificationsList !=
        null) Provider.of<GeneralProvider>(context, listen: false).clear();

    Provider.of<GeneralProvider>(context, listen: false)
        .getNotifications(context, 1, () {
      print("on refresh successfulley");
    });
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    print("_onLoading last page = " + lastPage.toString());
    if (nextPage <= lastPage) {
      print("load more = " +
          nextPage.toString() +
          " | last page = " +
          lastPage.toString());
      Provider.of<GeneralProvider>(context, listen: false)
          .getNotifications(context, nextPage, () {
        print("on loading successfully >> nextPage = " + nextPage.toString());
      });
      nextPage += 1;
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }
  }
}
