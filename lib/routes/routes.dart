import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/view/app/app_template.dart';
import 'package:pos_portal/view/new_product/product_action.dart';
import 'package:pos_portal/view/product/product_action.dart';
import 'package:pos_portal/view/setting/edit_struk_page.dart';
import 'package:pos_portal/view/setting/setting_page.dart';
import 'package:pos_portal/view/setting/setting_printer.dart';
import 'package:pos_portal/view/setting/webhook_setting.dart';
import 'package:pos_portal/view/transaction/cash_payment.dart';
import 'package:pos_portal/view/transaction/checkout_confirmation.dart';
import 'package:pos_portal/view/transaction/failed_transaction.dart';
import 'package:pos_portal/view/transaction/history_transaction.dart';
import 'package:pos_portal/view/transaction/new_transaction.dart';
import 'package:pos_portal/view/transaction/qris_payment.dart';
import 'package:pos_portal/view/transaction/success_transaction.dart';
import 'package:pos_portal/view_model/navigation_view_model.dart';
import '../view/home/home_page.dart';
import '../view/product/product_page.dart';
import '../view/transaction/transaction_page.dart';

class Routes {
  static final NavigationViewModel _viewModel = NavigationViewModel();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.ROOT:
        return MaterialPageRoute(builder: (_) => const AppTemplate());
      case RoutesName.home:
        _viewModel.saveSelectedIndex(0);
        return MaterialPageRoute(builder: (_) => const AppTemplate());
      case RoutesName.product:
        _viewModel.saveSelectedIndex(1);
        return MaterialPageRoute(builder: (_) => const AppTemplate());
      case RoutesName.productAction:
        return MaterialPageRoute(builder: (_) => const NewProductAction(), settings: settings);
      case RoutesName.transaction:
        _viewModel.saveSelectedIndex(2);
        return MaterialPageRoute(builder: (_) => const AppTemplate());
      case RoutesName.setting:
        _viewModel.saveSelectedIndex(3);
        return MaterialPageRoute(builder: (_) => const AppTemplate());
      case RoutesName.newTransaction:
        return MaterialPageRoute(builder: (_) => const NewTransactionPage());
      case RoutesName.transactionConfirm:
        return MaterialPageRoute(builder: (_) => const PaymentMethodPage(), settings: settings);
      case RoutesName.cashPayment:
        return MaterialPageRoute(builder: (_) => const CashPayment(), settings: settings);
      case RoutesName.qrisPayment:
        return MaterialPageRoute(builder: (_) => const QrisPayment(), settings: settings);
      case RoutesName.successPayment:
        return MaterialPageRoute(builder: (_) => const SuccessPayment(), settings: settings);
      case RoutesName.failedPayment:
        return MaterialPageRoute(builder: (_) => const FailedTransaction(), settings: settings);
      case RoutesName.transactionDetail:
        return MaterialPageRoute(builder: (_) => const HistoryTransaction(), settings: settings);
      case RoutesName.settingStruk:
        return MaterialPageRoute(builder: (_) => const EditStruk());
      case RoutesName.settingPrinter:
        return MaterialPageRoute(builder: (_) => const SettingPrinter());
      case RoutesName.settingWebHook:
        return MaterialPageRoute(builder: (_) => const WebHookPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
