package tap.company.card_flutter_example;

import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    private final  int REQUEST_ID_MULTIPLE_PERMISSIONS = 2;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        checkAndroidVersion();
        
    }

    private void checkAndroidVersion() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            checkAndRequestPermissions();
        } else {
            // code for lollipop and pre-lollipop devices
        }
    }

    private boolean checkAndRequestPermissions() {
        int camera  = ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA);
        ArrayList<String> listPermissionsNeeded = new ArrayList();

        if (camera != PackageManager.PERMISSION_GRANTED) {
            listPermissionsNeeded.add(android.Manifest.permission.CAMERA);
        }

        if (!listPermissionsNeeded.isEmpty()) {
            ActivityCompat.requestPermissions(
                    MainActivity.this, listPermissionsNeeded.toArray(new String[0]), REQUEST_ID_MULTIPLE_PERMISSIONS);
            return false;
        }
        return true;
    }


}
