import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../i18n/strings.g.dart';

enum MessageBoxType {
  close,
  ok,
  okCancel,
  yesNo,
  retryCancel,
}

class MessageBoxOptions {
  MessageBoxType type;
  Color titleColor;
  bool button0Negative;
  bool button1Negative;
  bool barrierDismissible;

  MessageBoxOptions({
    this.type = MessageBoxType.close,
    this.titleColor = Colors.black,
    this.button0Negative = false,
    this.button1Negative = false,
    this.barrierDismissible = false,
  });
}

/// Generic message dialog box.
class MessageBox {
  static final log = Logger('MessageBox');

  // ----------------------------------------------------------------------

  static Future<bool?> show({
    required BuildContext context,
    required String message,
    required String caption,
    required MessageBoxOptions options,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: options.barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          caption,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: options.titleColor,
          ),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message),
          ],
        ),
        actions: _buildButtons(context, options),
      ),
    );
  }

  static List<Widget> _buildButtons(
    BuildContext context,
    MessageBoxOptions options,
  ) {
    // expand type to button0 and/or button1
    String button0;
    String? button1;
    switch (options.type) {
      case MessageBoxType.close:
        button0 = t.common.close;
        break;
      case MessageBoxType.ok:
        button0 = t.common.ok;
        break;
      case MessageBoxType.okCancel:
        button0 = t.common.ok;
        button1 = t.common.cancel;
        break;
      case MessageBoxType.yesNo:
        button0 = t.common.yes;
        button1 = t.common.no;
        break;
      case MessageBoxType.retryCancel:
        button0 = t.common.retry;
        button1 = t.common.cancel;
        break;
    }

    // build button list
    if (button1 != null) {
      return <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            primary: options.button1Negative ? Colors.red : Colors.blue,
          ),
          child: Text(button1),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          style: TextButton.styleFrom(
            primary: options.button0Negative ? Colors.red : Colors.blue,
          ),
          child: Text(button0),
          onPressed: () => Navigator.pop(context, true),
        ),
      ];
    } else {
      return <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            primary: options.button0Negative ? Colors.red : Colors.blue,
          ),
          child: Text(button0),
          onPressed: () => Navigator.pop(context),
        ),
      ];
    }
  }

  // ----------------------------------------------------------------------

  /// Show generic information.
  static Future<void> info(
    BuildContext context,
    String message,
  ) {
    return show(
      context: context,
      message: message,
      caption: t.messageBox.info.title,
      options: MessageBoxOptions(
        barrierDismissible: true,
      ),
    );
  }

  /// Show warning.
  static Future<void> warning(
    BuildContext context,
    String message,
  ) {
    return show(
      context: context,
      message: message,
      caption: t.messageBox.warning.title,
      options: MessageBoxOptions(
        titleColor: Colors.orange,
        barrierDismissible: true,
      ),
    );
  }

  /// Show error.
  static Future<void> error(
    BuildContext context,
    String message,
  ) {
    return show(
      context: context,
      message: message,
      caption: t.messageBox.error.title,
      options: MessageBoxOptions(
        titleColor: Colors.red,
        barrierDismissible: false,
      ),
    );
  }

  /// Show question.
  static Future<bool?> question(
    BuildContext context,
    String message, [
    MessageBoxOptions? moreOptions,
  ]) {
    final options = moreOptions ?? MessageBoxOptions();
    options.type = MessageBoxType.yesNo;
    options.titleColor = Colors.blue;
    options.barrierDismissible = false;
    return show(
      context: context,
      message: message,
      caption: t.messageBox.question.title,
      options: options,
    );
  }
}
