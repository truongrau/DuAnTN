import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/constants/size.dart';
import 'package:managerfoodandcoffee/src/firebasehelper/firebasestore_helper.dart';

class giohang_admin extends StatefulWidget {
  final String tenban;
  const giohang_admin({
    super.key,
    required this.tenban,
  });

  @override
  State<giohang_admin> createState() => _giohang_adminState();
}

class _giohang_adminState extends State<giohang_admin> {
  bool thanhtoan = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    thanhtoan = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("BÀN SÔ ${widget.tenban}"),
        ),
        body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 2,
              )),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text("Thông tin Bàn số ${widget.tenban}"),
                ),
                StreamBuilder(
                  stream: FirestoreHelper.readgiohang(widget.tenban),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("lỗi"),
                      );
                    }
                    if (snapshot.hasData) {
                      final giohang = snapshot.data;
                      return SizedBox(
                        width: double.infinity,
                        height: SizeConfig.screenHeight / 1.2,
                        child: ListView.builder(
                          itemCount: giohang!.length,
                          itemBuilder: (context, index) {
                            final giohangindex = giohang[index];
                            return Container(
                              width: SizeConfig.screenWidth / 2,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: getProportionateScreenWidth(20),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF5F6F9),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: cacheNetWorkImage(
                                            giohangindex.hinhanh,
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: getProportionateScreenWidth(5),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            giohangindex.tensp,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: "\ ${giohangindex.giasp}",
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "x ${giohangindex.soluong}")
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                          "  VND: ${giohangindex.soluong * giohangindex.giasp}"),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                StreamBuilder(
                  stream: FirestoreHelper.readtinhtrang(widget.tenban),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("lỗi"),
                      );
                    }
                    if (snapshot.hasData) {
                      final tinhtrangthanhtoan = snapshot.data;
                      for (var i = 0; i < tinhtrangthanhtoan!.length; i++) {
                        if (tinhtrangthanhtoan[i].idtinhtrang ==
                            widget.tenban) {
                          thanhtoan = true;

                          break;
                        }
                      }
                      return Center(
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: thanhtoan == false
                              ? Text(
                                  "vui lòng chờ khách hàng chọn món hoàn tất")
                              : Text("xác nhận đợn hàng"),
                        ),
                      );
                    }
                    return Container(
                      height: 50,
                      width: double.infinity,
                      child: Center(
                          child: Row(
                        children: [
                          Text("vui long chờ khách hàng order xong  "),
                          CircularProgressIndicator()
                        ],
                      )),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
