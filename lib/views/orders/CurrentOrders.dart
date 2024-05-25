import 'package:drivers/AppLocalization.dart';
import 'package:drivers/constants/colors.dart';
import 'package:drivers/constants/constants.dart';
import 'package:drivers/constants/routes.dart';
import 'package:drivers/models/responses/order/OrderModel.dart';
import 'package:drivers/provider/GeneralProvider.dart';
import 'package:drivers/views/orders/OrderDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CurrentOrders extends StatefulWidget {
  static int currentOrdersLength = 0;
//  final VoidCallback onFlatButtonPressed;

//  CurrentOrders({Key key, @required this.onFlatButtonPressed}) : super(key: key);
  @override
  _CurrentOrders createState() => _CurrentOrders();
}

class _CurrentOrders extends State<CurrentOrders> {
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

    Provider.of<GeneralProvider>(context, listen: false).clear();
    Provider.of<GeneralProvider>(context, listen: false)
        .getOrdersData(context, 1, CURRENT, () {
      print("successfully");
      setState(() {
        lastPage =
            Provider.of<GeneralProvider>(context, listen: false).lastPage;
        CurrentOrders.currentOrdersLength = Provider.of<GeneralProvider>(context,
            listen: false).ordersDataCurrentList.length;
        print("ordersDataCurrentList.length = "+Provider.of<GeneralProvider>(context,
            listen: false).ordersDataCurrentList.length.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralProvider>(
        builder: (context, generalProvider, child) {
      return Provider.of<GeneralProvider>(context, listen: false).isLoading
          ? generalProvider.ordersDataCurrentList != null
              ? generalProvider.ordersDataCurrentList.length != 0
                  ? SmartRefresher(
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
                      child: ListView.builder(
                          shrinkWrap: true,
//                        physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              generalProvider.ordersDataCurrentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return itemContainer(generalProvider.ordersDataCurrentList[index]);
                          }),
                    )
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.sp),
                        child: Text(
                          getTranslated(context, "thereOrderNoContent"),
                          style: TextStyle(
                            fontFamily: NEO_SANS_FONT_FAMILY,
                            fontSize: 40.ssp,
                            color: gray00,
                          ),
                        ),
                      ),
                    )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.sp),
                    child: Text(
                      getTranslated(context, "thereOrderNoContent"),
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
            );
    });
  }

  Widget itemContainer(OrderModel orderModel) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            child: OrderDetails(orderModel: orderModel,),
            create: (context) => GeneralProvider(),
          )
        ));
      },
      child: Container(
        margin: EdgeInsetsDirectional.only(top: 65.h),
        height: 350.h,
        color: white,
        child: texts(orderModel),
      ),
    );
  }

  Widget texts(OrderModel orderModel) {
    return Container(
      width: MediaQuery.of(context).size.width * 1.2 / 2,
      margin: EdgeInsetsDirectional.only(start: 35.sp, end: 35.sp),
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: AlignmentDirectional.centerStart,
                margin: EdgeInsetsDirectional.only(bottom: 25.h),
                child: Text(orderModel.orderNumber,
                    style: (TextStyle(
                        fontFamily: NEO_SANS_FONT_FAMILY,
                        color: blackline,
                        fontSize: 41.ssp))),
              ),
              Container(
                alignment: AlignmentDirectional.centerEnd,
                margin: EdgeInsetsDirectional.only(bottom: 25.h),
                child: Text(orderModel.finalAmount.toString()+" "+getTranslated(context, "sr"),
                    style: (TextStyle(
                        fontFamily: NEO_SANS_FONT_FAMILY,
                        color: darkblue1,
                        fontSize: 39.ssp))),
              )
            ],
          ),
          Container(
            alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsetsDirectional.only(bottom: 25.h),
            child: Row(
              children: <Widget>[
                Text(getTranslated(context, 'Requested_on'),
                    style: (TextStyle(
                        fontFamily: NEO_SANS_FONT_FAMILY,
                        color: gray0,
                        fontSize: 34.ssp))),
                Text(orderModel.createdAt.split(" ")[0],
                    style: (TextStyle(
                        fontFamily: NEO_SANS_FONT_FAMILY,
                        color: gray0,
                        fontSize: 34.ssp))),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(getTranslated(context, 'Order_Status')+" ",
                      style: (TextStyle(
                          fontFamily: NEO_SANS_FONT_FAMILY,
                          color: gray0,
                          fontSize: 34.ssp))),
                  Text(orderModel.statusName,
                      style: (TextStyle(
                          fontFamily: NEO_SANS_FONT_FAMILY,
                          color: darkblack,
                          fontSize: 34.ssp))),
                ],
              ),
              Text(getTranslated(context, 'Order_Details'),
                  style: (TextStyle(
                      fontFamily: NEO_SANS_FONT_FAMILY,
                      color: primaryColor,
                      fontSize: 36.ssp))),
            ],
          ),
        ],
      ),
    );
  }

  void onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    if (Provider.of<GeneralProvider>(context, listen: false)
            .ordersDataCurrentList !=
        null) Provider.of<GeneralProvider>(context, listen: false).clear();

    Provider.of<GeneralProvider>(context, listen: false)
        .getOrdersData(context, 1, CURRENT, () {
      print("on refresh successfulley" +
          Provider.of<GeneralProvider>(context, listen: false)
              .lastPage
              .toString());
      lastPage = Provider.of<GeneralProvider>(context, listen: false).lastPage;
      CurrentOrders.currentOrdersLength = Provider.of<GeneralProvider>(context,
          listen: false).ordersDataCurrentList.length;
      print("onLoading >> ordersDataCurrentList.length = "+Provider.of<GeneralProvider>(context,
          listen: false).ordersDataCurrentList.length.toString());
      nextPage = 2;
      refreshController.refreshCompleted();
    });
  }

  void onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    lastPage = homeCategoriesData.pagination.lastPage;
    print("_onLoading last page = " + lastPage.toString());
    if (nextPage <= lastPage) {
//        print("last jobs size = "+categoryList.length.toString());
      print("load more = " +
          nextPage.toString() +
          " | last page = " +
          lastPage.toString());
      Provider.of<GeneralProvider>(context, listen: false)
          .getOrdersData(context, nextPage, CURRENT, () {
        print("on loading successfully >> nextPage = " + nextPage.toString());
        lastPage =
            Provider.of<GeneralProvider>(context, listen: false).lastPage;
      });
      nextPage += 1;
      refreshController.loadComplete();
    } else {
      print("load more = " +
          nextPage.toString() +
          " | last page = " +
          lastPage.toString());
      refreshController.loadNoData();
    }
  }
}
