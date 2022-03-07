import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final Permission _permissionCam = Permission.camera;
  bool _checkingPermission = false;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webview Camera'),
      ),
      body: InAppWebView(
        initialOptions: options,
        initialUrlRequest: URLRequest(url: Uri.parse("https://webcamtests.com/")),
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
              resources: resources, action: PermissionRequestResponseAction.GRANT);
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_checkingPermission) {
      _checkingPermission = true;
      _checkPermission(_permissionCam).then((_) => _checkingPermission = false);
    }
  }

  Future<void> _checkPermission(Permission permission) async {
    final status = await permission.request();
    if (status == PermissionStatus.granted) {
    } else if (status == PermissionStatus.denied) {
      await permission.request();
    } else if (status == PermissionStatus.permanentlyDenied) {
      await permission.request();
    }
  }
}
