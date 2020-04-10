package com.laodev.onepay.activity;

import androidx.appcompat.app.AppCompatActivity;

import android.animation.Animator;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.daimajia.androidanimations.library.Techniques;
import com.daimajia.androidanimations.library.YoYo;
import com.laodev.onepay.R;
import com.laodev.onepay.util.AppUtils;
import com.laodev.onepay.util.LocaleHelper;
import com.mukesh.OnOtpCompletionListener;
import com.mukesh.OtpView;

public class SignActivity extends AppCompatActivity {

    private LinearLayout llt_login_tab, llt_register_tab;
    private LinearLayout llt_sign, llt_verify, llt_success, llt_end_record;

    private LinearLayout llt_login, llt_register;
    private TextView lbl_sign, lbl_skip;

    private ImageView img_back;

    private OtpView otp_code;

    private boolean isLogin = true;
    private boolean isFirst = true;

    public void onClickTabLogin(View view) {
        if (!isLogin) {
            initWithLoginTab();
        }
    }

    public void onClickTabRegister(View view) {
        if (isLogin) {
            initWithRegisterTab();
        }
    }

    public void onClickLltSign(View view) {
        if (lbl_sign.getText().equals(getText(R.string.sign_next))) {
            // Register Action
            initWithVerifyView();
        } else {
            // Login Action
            AppUtils.showOtherActivity(this, ControlActivity.class, -1);
        }
    }

    public void onClickLltSkip(View view) {
        AppUtils.showOtherActivity(this, ControlActivity.class, -1);
    }

    public void onClickLltEndRecord(View view) {
        AppUtils.showOtherActivity(this, SuccessActivity.class, -1);
    }

    private void initWithEvent() {
        img_back.setOnClickListener(v -> initWithLoginTab());

        otp_code.setOtpCompletionListener(otp -> {
            if (otp.equals("1234")) {
                AppUtils.hideKeyboard(this);
                initWithSuccessView();
            } else {
                Toast.makeText(SignActivity.this, R.string.sign_wrong_code, Toast.LENGTH_SHORT).show();
            }
        });
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign);

        // Change Status Bar Color
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            getWindow().setStatusBarColor(getColor(R.color.colorMainBlue));
        } else {
            getWindow().setStatusBarColor(getResources().getColor(R.color.colorMainBlue));
        }

        initUIView();
    }

    private void initUIView() {
        llt_login_tab = findViewById(R.id.llt_sign_login);
        llt_register_tab = findViewById(R.id.llt_sign_register);

        llt_sign = findViewById(R.id.llt_sign);
        llt_verify = findViewById(R.id.llt_sign_verify);
        llt_success = findViewById(R.id.llt_sign_verify_success);
        llt_end_record = findViewById(R.id.llt_sign_end_record);

        llt_login = findViewById(R.id.llt_tab_login);
        llt_register = findViewById(R.id.llt_tab_register);

        lbl_sign = findViewById(R.id.lbl_sign);
        lbl_skip = findViewById(R.id.lbl_sign_skip);

        img_back = findViewById(R.id.img_sign_back);

        otp_code = findViewById(R.id.otp_sign_code);

        initWithLoginTab();

        initWithEvent();
    }

    private void initWithLoginTab() {
        if (isFirst) {
            llt_login_tab.setAlpha((float) 1.0);
            llt_register_tab.setAlpha((float) 0.0);
            isFirst = false;
        } else {
            YoYo.with(Techniques.FadeIn)
                    .duration(700)
                    .playOn(llt_login_tab);
            YoYo.with(Techniques.FadeOut)
                    .duration(700)
                    .playOn(llt_register_tab);
        }

        llt_sign.setVisibility(View.VISIBLE);
        llt_verify.setVisibility(View.GONE);
        llt_success.setVisibility(View.GONE);
        llt_end_record.setVisibility(View.GONE);
        img_back.setVisibility(View.INVISIBLE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            llt_login.setBackgroundColor(getColor(R.color.colorMainWhite));
        } else {
            llt_login.setBackgroundColor(getResources().getColor(R.color.colorMainWhite));
        }

        llt_register.setBackground(getDrawable(R.drawable.btn_grad_right_12));

        lbl_sign.setText(R.string.sign_signin);
        lbl_skip.setText(R.string.sign_entry);

        isLogin = true;
    }

    private void initWithRegisterTab() {
        YoYo.with(Techniques.FadeIn)
                .duration(700)
                .playOn(llt_register_tab);
        YoYo.with(Techniques.FadeOut)
                .duration(700)
                .playOn(llt_login_tab);

        llt_sign.setVisibility(View.VISIBLE);
        llt_verify.setVisibility(View.GONE);
        llt_success.setVisibility(View.GONE);
        llt_end_record.setVisibility(View.GONE);
        img_back.setVisibility(View.INVISIBLE);

        llt_login.setBackground(getDrawable(R.drawable.btn_grad_left_12));

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            llt_register.setBackgroundColor(getColor(R.color.colorMainWhite));
        } else {
            llt_register.setBackgroundColor(getResources().getColor(R.color.colorMainWhite));
        }

        lbl_sign.setText(R.string.sign_next);
        lbl_skip.setText(R.string.sign_record);

        isLogin = false;
    }

    private void initWithVerifyView() {
        isFirst = true;
        llt_sign.setVisibility(View.GONE);
        llt_verify.setVisibility(View.VISIBLE);
        llt_success.setVisibility(View.GONE);
        llt_end_record.setVisibility(View.GONE);
        img_back.setVisibility(View.VISIBLE);
    }

    private void initWithSuccessView() {
        isFirst = true;
        llt_sign.setVisibility(View.GONE);
        llt_verify.setVisibility(View.GONE);
        llt_success.setVisibility(View.VISIBLE);
        llt_end_record.setVisibility(View.GONE);
        img_back.setVisibility(View.VISIBLE);

        new Handler().postDelayed(this::initWithEndRecordView, 2000);
    }

    private void initWithEndRecordView() {
        isFirst = true;
        llt_sign.setVisibility(View.GONE);
        llt_verify.setVisibility(View.GONE);
        llt_success.setVisibility(View.GONE);
        llt_end_record.setVisibility(View.VISIBLE);
        img_back.setVisibility(View.VISIBLE);
    }

    @Override
    public void onBackPressed() {
        initWithLoginTab();
    }

}
