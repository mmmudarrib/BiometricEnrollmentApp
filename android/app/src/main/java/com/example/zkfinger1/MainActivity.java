package com.example.zkfinger1;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.example.zkfinger1.ZKUSBManager.ZKUSBManager;
import com.example.zkfinger1.ZKUSBManager.ZKUSBManagerListener;
import com.example.zkfinger10demo.util.PermissionUtils;
import com.zkteco.android.biometric.FingerprintExceptionListener;
import com.zkteco.android.biometric.core.device.ParameterHelper;
import com.zkteco.android.biometric.core.device.TransportType;
import com.zkteco.android.biometric.core.utils.LogHelper;
import com.zkteco.android.biometric.core.utils.ToolUtils;
import com.zkteco.android.biometric.module.fingerprintreader.FingerprintCaptureListener;
import com.zkteco.android.biometric.module.fingerprintreader.FingerprintSensor;
import com.zkteco.android.biometric.module.fingerprintreader.FingprintFactory;
import com.zkteco.android.biometric.module.fingerprintreader.ZKFingerService;
import com.zkteco.android.biometric.module.fingerprintreader.exception.FingerprintException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import io.flutter.plugin.common.MethodChannel.Result;
public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "abc";
    private static final int ZKTECO_VID = 0x1b55;
    private static final int LIVE20R_PID = 0x0120;
    private static final int LIVE10R_PID = 0x0124;
    private static final String TAG = "MainActivity";
    private final int REQUEST_PERMISSION_CODE = 9;
    private ZKUSBManager zkusbManager = null;
    private FingerprintSensor fingerprintSensor = null;
    private int usb_vid = ZKTECO_VID;
    private int usb_pid = 0;
    private boolean bStarted = false;
    private int deviceIndex = 0;
    private boolean isReseted = false;
    private String strUid = null;

    private  String   strFeature=null;
    private final static int ENROLL_COUNT = 3;
    private int enroll_index = 0;
    private byte[][] regtemparray = new byte[3][2048];  //register template buffer array
    private boolean bRegister = false;
    private UsbManager m_Manager;

    private MethodChannel channel;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler((call, result) -> {
            if (call.method.equals("start")) {
                String response = onBnStart();
                result.success(response);
            } else if (call.method.equals("listDevices")) {
                listDevices(result);
            }else  if (call.method.equals("startRegister")) {
                String response = startRegister();
                result.success(response);
            }
            else  if (call.method.equals("startIdentify")) {
                String response = startIdentify();
                result.success(response);
            }   else  if (call.method.equals("setUserID")) {
                String response = setUserID(call.argument("uid"));
                result.success(response);
            }else  if (call.method.equals("getUserID")) {
                String response = getUid();
                result.success(response);
            }else  if (call.method.equals("getFeature")) {
                String response = getFeature();
                result.success(response);
            }


        });
    }
    public String setUserID(String uid) {
        channel.invokeMethod("settingUserID",uid);
        strUid=uid;
        return "UID stored";
    }
    public String startRegister() {
      bRegister=true;
      return "RegisterStart";
    }
    public String getUid() {

        return strUid;
    }

    public String getFeature() {

        return strFeature;
    }
    public String startIdentify() {
        bRegister=false;
        return "IdentifyStart";
    }

    public String onBnStart() {
        if (bStarted) {
            return ("Device already connected!");

        }
        if (!enumSensor()) {
            return ("404");

        }
        tryGetUSBPermission();
        return "connected";
    }

    private void listDevices(Result result) {
        channel.invokeMethod("list", "abc");
        Map<String, UsbDevice> devices = m_Manager.getDeviceList();
        if (devices == null) {
            result.error(TAG, "Could not get USB device list.", null);
            return;
        }
        List<HashMap<String, Object>> transferDevices = new ArrayList<>();

        for (UsbDevice device : devices.values()) {
            transferDevices.add(serializeDevice(device));
        }
        result.success(transferDevices);
    }

    private HashMap<String, Object> serializeDevice(UsbDevice device) {
        HashMap<String, Object> dev = new HashMap<>();
        dev.put("deviceName", device.getDeviceName());
        dev.put("vid", device.getVendorId());
        dev.put("pid", device.getProductId());
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            dev.put("manufacturerName", device.getManufacturerName());
            dev.put("productName", device.getProductName());
            dev.put("interfaceCount", device.getInterfaceCount());
            /* if the app targets SDK >= android.os.Build.VERSION_CODES.Q and the app does not have permission to read from the device. */
            try {
                dev.put("serialNumber", device.getSerialNumber());
            } catch (java.lang.SecurityException e) {
            }
        }
        dev.put("deviceId", device.getDeviceId());
        return dev;
    }

    void doRegister(byte[] template) {
        byte[] bufids = new byte[256];
        int ret;

        if (enroll_index > 0 && (ret = ZKFingerService.verify(regtemparray[enroll_index - 1], template)) <= 0) {
            bRegister = false;
            enroll_index = 0;
            channel.invokeMethod("registering", "please press the same finger 3 times for the enrollment, cancel enroll, socre=");
        }
        System.arraycopy(template, 0, regtemparray[enroll_index], 0, 2048);
        enroll_index++;
        if (enroll_index == ENROLL_COUNT) {
            bRegister = false;
            enroll_index = 0;
            byte[] regTemp = new byte[2048];
            if (0 < (ret = ZKFingerService.merge(regtemparray[0], regtemparray[1], regtemparray[2], regTemp))) {
                int retVal = 0;
                retVal = ZKFingerService.save(regTemp, strUid);
                if (0 == retVal) {
                     strFeature = Base64.encodeToString(regTemp, 0, ret, Base64.NO_WRAP);
                    //dbManager.insertUser(strUid, strFeature);
                    channel.invokeMethod("Done Registering", strFeature);
                } else {
                    channel.invokeMethod("FAIL Registering", ret);
                }
            } else {
                channel.invokeMethod("FAIL Registering", "failure");
            }
        } else {
            String str = "Place the Finger on Scanner" + (3 - enroll_index) + " times";
            channel.invokeMethod("registering", str);
        }
    }



    void doIdentify(byte[] template)
    {
        byte[] bufids = new byte[256];
        int ret = ZKFingerService.identify(template, bufids, 70, 1);
        if (ret > 0) {
            String strRes[] = new String(bufids).split("\t");
            String res= strRes[0].trim();
            channel.invokeMethod("Identify", res);
        } else {
            String res="identify fail, ret=" + ret;
            channel.invokeMethod("IdentifyFail", res);
        }
    }

    private FingerprintCaptureListener fingerprintCaptureListener = new FingerprintCaptureListener() {
        @Override
        public void captureOK(byte[] fpImage) {
            runOnUiThread(new Runnable() {
                public void run() {
                    channel.invokeMethod("captureOK","abc");
                }
            });
        }

        @Override
        public void captureError(FingerprintException e) {
            // nothing to do
        }

        @Override
        public void extractOK(byte[] fpTemplate) {
            runOnUiThread(new Runnable() {
                public void run() {
                    if(bRegister) {
                        channel.invokeMethod("extractOK", "abc");
                        doRegister(fpTemplate);
                    }else{
                        doIdentify(fpTemplate);
                    }
                }
            });

        }

        @Override
        public void extractError(int i) {
            // nothing to do
        }
    };

    private FingerprintExceptionListener fingerprintExceptionListener = new FingerprintExceptionListener() {
        @Override
        public void onDeviceException() {
            LogHelper.e("usb exception!!!");
            if (!isReseted) {
                try {
                    fingerprintSensor.openAndReboot(deviceIndex);
                } catch (FingerprintException e) {
                    e.printStackTrace();
                }
                isReseted = true;
            }
        }
    };

    private ZKUSBManagerListener zkusbManagerListener = new ZKUSBManagerListener() {
        @Override
        public void onCheckPermission(int result) {
              afterGetUsbPermission();
        }

        @Override
        public void onUSBArrived(UsbDevice device) {
            if (bStarted)
            {
                closeDevice();
                tryGetUSBPermission();
            }
        }

        @Override
        public void onUSBRemoved(UsbDevice device) {
            LogHelper.d("usb removed!");
        }
    };
    private void checkStoragePermission() {
        String[] permission = new String[]{
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE
        };
        ArrayList<String> deniedPermissions = PermissionUtils.checkPermissions(this, permission);
        if (deniedPermissions.isEmpty()) {
            //permission all granted
            Log.i(TAG, "[checkStoragePermission]: all granted");
        } else {
            int size = deniedPermissions.size();
            String[] deniedPermissionArray = deniedPermissions.toArray(new String[size]);
            PermissionUtils.requestPermission(this, deniedPermissionArray, REQUEST_PERMISSION_CODE);
        }
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case REQUEST_PERMISSION_CODE:
                boolean granted = true;
                for (int result : grantResults) {
                    if (result != PackageManager.PERMISSION_GRANTED) {
                        granted = false;
                    }
                }
                if (granted) {
                    Toast.makeText(this, "Permission granted", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(this, "Permission Denied,The application can't run on this device", Toast.LENGTH_SHORT).show();
                }
            default:
                break;
        }
    }

    private void createFingerprintSensor()
    {
        if (null != fingerprintSensor)
        {
            FingprintFactory.destroy(fingerprintSensor);
            fingerprintSensor = null;
        }
        // Define output log level
        LogHelper.setLevel(Log.VERBOSE);
        LogHelper.setNDKLogLevel(Log.ASSERT);
        // Start fingerprint sensor
        Map deviceParams = new HashMap();
        //set vid
        deviceParams.put(ParameterHelper.PARAM_KEY_VID, usb_vid);
        //set pid
        deviceParams.put(ParameterHelper.PARAM_KEY_PID, usb_pid);
        fingerprintSensor = FingprintFactory.createFingerprintSensor(getApplicationContext(), TransportType.USB, deviceParams);
    }

    private boolean enumSensor()
    {
        UsbManager usbManager = (UsbManager)this.getSystemService(Context.USB_SERVICE);
        for (UsbDevice device : usbManager.getDeviceList().values()) {
            int device_vid = device.getVendorId();
            int device_pid = device.getProductId();
            if (device_vid == ZKTECO_VID && (device_pid == LIVE20R_PID || device_pid == LIVE10R_PID))
            {
                usb_pid = device_pid;
                return true;
            }
        }
        return false;
    }


    private void tryGetUSBPermission() {
        zkusbManager.initUSBPermission(usb_vid, usb_pid);
    }

    private String afterGetUsbPermission()
    {
      return  openDevice();
    }

    private String openDevice()
    {
        createFingerprintSensor();
        bRegister = false;
        enroll_index = 0;
        isReseted = false;
        try {
            //fingerprintSensor.setCaptureMode(1);
            fingerprintSensor.open(deviceIndex);
            //load all templates form db

            {
                // device parameter
                LogHelper.d("sdk version" + fingerprintSensor.getSDK_Version());
                LogHelper.d("firmware version" + fingerprintSensor.getFirmwareVersion());
                LogHelper.d("serial:" + fingerprintSensor.getStrSerialNumber());
                LogHelper.d("width=" + fingerprintSensor.getImageWidth() + ", height=" + fingerprintSensor.getImageHeight());
            }
            fingerprintSensor.setFingerprintCaptureListener(deviceIndex, fingerprintCaptureListener);
            fingerprintSensor.SetFingerprintExceptionListener(fingerprintExceptionListener);
            fingerprintSensor.startCapture(deviceIndex);
            bStarted = true;
            return "connect success!";
        } catch (FingerprintException e) {
            e.printStackTrace();
            // try to  reboot the sensor
            try {
                fingerprintSensor.openAndReboot(deviceIndex);
            } catch (FingerprintException ex) {
                ex.printStackTrace();
            }
            return"connect failed!";
        }
    }

    private void closeDevice()
    {
        if (bStarted)
        {
            try {
                fingerprintSensor.stopCapture(deviceIndex);
                fingerprintSensor.close(deviceIndex);
            } catch (FingerprintException e) {
                e.printStackTrace();
            }
            bStarted = false;
        }
    }



    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        checkStoragePermission();
        zkusbManager = new ZKUSBManager(this.getApplicationContext(), zkusbManagerListener);
        m_Manager = (UsbManager) this.getApplicationContext().getSystemService(android.content.Context.USB_SERVICE);
        zkusbManager.registerUSBPermissionReceiver();
    }

}
