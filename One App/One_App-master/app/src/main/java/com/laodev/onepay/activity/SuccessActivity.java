package com.laodev.onepay.activity;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Build;
import android.os.Bundle;
import android.os.Handler;

import com.laodev.onepay.R;
import com.laodev.onepay.util.AppUtils;

public class SuccessActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_success);

        // Change Status Bar Color
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            getWindow().setStatusBarColor(getColor(R.color.colorMainBlue));
        } else {
            getWindow().setStatusBarColor(getResources().getColor(R.color.colorMainBlue));
        }

        new Handler().postDelayed(this::showControlActivity, 2000);
    }

    private void showControlActivity() {
        AppUtils.showOtherActivity(this, ControlActivity.class, -1);
    }

    @Override
    public void onBackPressed() {
        //
    }
}
