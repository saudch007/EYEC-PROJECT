// Android implementation in Java
package com.example.sample;

import android.content.Intent;
import android.net.Uri;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class CallHelperPlugin implements MethodCallHandler {

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "call_helper");
        channel.setMethodCallHandler(new CallHelperPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("makePhoneCall")) {
            String phoneNumber = call.argument("phoneNumber");
            makePhoneCall(phoneNumber);
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    private void makePhoneCall(String phoneNumber) {
        Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + phoneNumber));
        // You may need to check for CALL_PHONE permission before making the call
        // Example: if (checkSelfPermission(Manifest.permission.CALL_PHONE) == PackageManager.PERMISSION_GRANTED)
        // For simplicity, it's assumed that the permission is granted in this example
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        Registrar registrar = RegistrarManager.currentActivity.getRegistrar();
        registrar.activity().startActivity(intent);
    }
}
