package com.laodev.onepay.activity;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import android.os.Build;
import android.os.Bundle;
import android.os.Handler;

import com.laodev.onepay.R;
import com.laodev.onepay.util.AppUtils;
import com.laodev.onepay.util.LocaleHelper;

import java.time.LocalDate;

import static com.laodev.onepay.util.LocaleHelper.getLanguage;

public class SplashActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        LocaleHelper.setLocale(this, LocaleHelper.getLanguage(this));

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);

        // Change Status Bar Color
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            getWindow().setStatusBarColor(getColor(R.color.colorMainBlue));
        } else {
            getWindow().setStatusBarColor(getResources().getColor(R.color.colorMainBlue));
        }

        new Handler().postDelayed(this::onNextActivity, 1500);
    }

    private void onNextActivity() {
        AppUtils.showOtherActivity(this, SignActivity.class, -1);
    }

}
