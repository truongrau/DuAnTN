import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/controller_getx/auth_controller.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/right_panel/manage_table/manager_table.dart';
import 'package:managerfoodandcoffee/src/controller_getx/brightness_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/table_model.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

// ignore: must_be_immutable
class FirstWidget extends StatefulWidget {
  const FirstWidget({super.key});

  @override
  State<FirstWidget> createState() => _FirstWidgetState();
}

class _FirstWidgetState extends State<FirstWidget> {
  final tableController = Get.put(TableController());
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    ColorScheme color = colorScheme(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                authController.urlAvatar.value != ''
                    ? CircleAvatar(
                        radius: 14,
                        backgroundImage:
                            NetworkImage(authController.urlAvatar.value),
                      )
                    : const CircleAvatar(
                        radius: 14,
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                const SizedBox(width: 8),
                Text(
                  authController.userName.value ?? 'Guest',
                  style: text(context).titleMedium?.copyWith(),
                )
              ],
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color.surfaceVariant,
                  child: IconButton(
                    onPressed: () => Get.dialog(const CreateTable()),
                    icon: Icon(
                      Icons.add,
                      size: 16,
                      color: color.primary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: StreamBuilder(
                    stream: FirestoreHelper.readtinhtrangtt(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return SingleChildScrollView(
                          child: Text("Lỗi: ${snapshot.error.toString()}"),
                        );
                      }
                      if (snapshot.hasData) {
                        final tinhtrangtt = snapshot.data;
                        for (var i = 0; i < tinhtrangtt!.length; i++) {
                          if (tinhtrangtt[i].trangthai == "ordered") {
                            showSnackbar(tinhtrangtt[i].idtinhtrang.toString());
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: badges.Badge(
                            position: badges.BadgePosition.topStart(),
                            badgeAnimation: const badges.BadgeAnimation.fade(),
                            //lấy dự liệu order
                            badgeContent: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "${tinhtrangtt.length}",
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Tình trạng đơn'),
                                      content: SizedBox(
                                        // height: 300,
                                        width:
                                            400, // Điều chỉnh kích thước tùy theo nhu cầu của bạn
                                        child: ListView.builder(
                                          itemCount: tinhtrangtt.length,
                                          itemBuilder: (context, index) {
                                            final tinhtranttindex =
                                                tinhtrangtt[index];
                                            return Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: tinhtranttindex
                                                              .trangthai ==
                                                          "ordered"
                                                      ? Colors.green
                                                      : Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      child: Text(
                                                          "Bàn ${tinhtranttindex.idtinhtrang.toString()}:"),
                                                    ),
                                                    Text(tinhtranttindex
                                                                .trangthai ==
                                                            "ordered"
                                                        ? "Đã xác nhận đơn hàng, hãy chuẩn bị món!"
                                                        : "Đơn hàng đã được thanh toán, hãy chuẩn bị món!"),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Đóng hộp thoại.
                                          },
                                          child: const Text('Đóng'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.notifications,
                                size: 32,
                                color: color.surfaceVariant,
                              ),
                            ),
                          ),
                        );
                      }
                      return const Icon(Icons.notifications);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirestoreHelper.readtable(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return SingleChildScrollView(
                  child: Text("Lỗi: ${snapshot.error.toString()}"),
                );
              }
              if (snapshot.hasData) {
                final table = snapshot.data;
                //Sắp xếp tên bàn theo thứ tự nhỏ đén lớn theo tên bàn
                int compareByTenBan(TableModel a, TableModel b) {
                  return int.parse(a.tenban).compareTo(int.parse(b.tenban));
                }

                table?.sort(compareByTenBan);

                return Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Wrap(
                        children: table!.map((tableindex) {
                      return StreamBuilder(
                        stream: FirestoreHelper.readgiohang(tableindex.tenban),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return SingleChildScrollView(
                              child: Text("Lỗi: ${snapshot.error.toString()}"),
                            );
                          }
                          if (snapshot.hasData) {
                            final giohangtb = snapshot.data;
                            return FittedBox(
                              child: Container(
                                margin: const EdgeInsets.all(16),
                                child: badges.Badge(
                                    position: badges.BadgePosition.topEnd(),
                                    badgeAnimation:
                                        const badges.BadgeAnimation.fade(),
                                    showBadge: giohangtb!.isNotEmpty,
                                    badgeContent: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "${giohangtb.length}",
                                        style: text(context)
                                            .titleMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: tableController.isExpanded.value
                                          ? () {
                                              tableController.tableName.value =
                                                  tableindex.tenban;
                                            }
                                          : () {
                                              tableController.tableName.value =
                                                  tableindex.tenban;
                                              tableController.isExpanded.value =
                                                  true;
                                            },
                                      child: Container(
                                        width: 180,
                                        height: 180,
                                        // padding: const EdgeInsets.symmetric(
                                        //     vertical: 40, horizontal: 50),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 0.3,
                                            color: colorScheme(context)
                                                .surfaceVariant,
                                          ),
                                          gradient: !Get.put(
                                                      BrightnessController())
                                                  .isDarkMode
                                                  .value
                                              ? giohangtb.isNotEmpty
                                                  ? LinearGradient(
                                                      begin:
                                                          Alignment.bottomLeft,
                                                      end: Alignment.topRight,
                                                      colors: [
                                                        color.surfaceVariant
                                                            .withOpacity(0.3),
                                                        color.onSurfaceVariant
                                                            .withOpacity(0.3),
                                                      ],
                                                    )
                                                  : null
                                              : giohangtb.isEmpty
                                                  ? LinearGradient(
                                                      begin:
                                                          Alignment.bottomLeft,
                                                      end: Alignment.topRight,
                                                      colors: [
                                                        color.surfaceVariant
                                                            .withOpacity(0.3),
                                                        color.onSurfaceVariant
                                                            .withOpacity(0.3),
                                                      ],
                                                    )
                                                  : null,
                                          color: color.onPrimary,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 10,
                                              left: 20,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Bàn".toUpperCase(),
                                                    style: text(context)
                                                        .titleSmall,
                                                  ),
                                                  Text(
                                                      int.parse(tableindex
                                                                  .tenban) <
                                                              10
                                                          ? "0${tableindex.tenban}"
                                                          : tableindex.tenban,
                                                      style: text(context)
                                                          .displayMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 10,
                                              right: 10,
                                              child: Image.asset(
                                                giohangtb.isEmpty
                                                    ? "assets/images/table1.png"
                                                    : 'assets/images/order.png',
                                                height: 60,
                                                width: 60,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            );
                          }
                          return SingleChildScrollView(
                            child: Text("Lỗi: ${snapshot.error.toString()}"),
                          );
                        },
                      );
                    }).toList()),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> showSnackbar(String tenban) async {
    await Future.delayed(
        const Duration(seconds: 0)); // This ensures the build has completed
    Get.snackbar("Đã xác nhận ban số $tenban", '',
        duration: const Duration(seconds: 2));
  }
}
