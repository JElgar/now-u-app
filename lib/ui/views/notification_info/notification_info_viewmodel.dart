import 'package:nowu/app/app.locator.dart';
import 'package:nowu/models/Notification.dart';
import 'package:nowu/services/internal_notification_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationInfoViewModel extends BaseViewModel {
  final InternalNotification notification;

  NotificationInfoViewModel(this.notification);

  final _internalNotificationService = locator<InternalNotificationService>();
  final _routerService = locator<NavigationService>();

  Future dismissNotification() async {
    bool success =
        await _internalNotificationService.dismissNotification(notification.id);
    if (success) {
      _routerService.back();
    }
    // TODO inform user of issue
  }
}
