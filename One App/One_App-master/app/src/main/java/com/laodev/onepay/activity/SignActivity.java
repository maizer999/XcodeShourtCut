package com.laodev.onepay.activity;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.VolleyError;
import com.daimajia.androidanimations.library.Techniques;
import com.daimajia.androidanimations.library.YoYo;
import com.google.android.material.textfield.TextInputEditText;
import com.laodev.onepay.R;
import com.laodev.onepay.callbackinterface.APIResponse;
import com.laodev.onepay.util.AppUtils;
import com.laodev.onepay.volley.APIManager;
import com.laodev.onepay.volley.IVolleyCallback;
import com.laodev.onepay.volley.RequestQueueService;
import com.mukesh.OtpView;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class SignActivity extends AppCompatActivity {

    private LinearLayout llt_login_tab, llt_register_tab;
    private LinearLayout llt_sign, llt_verify, llt_success, llt_end_record;

    private LinearLayout llt_login, llt_register;
    private TextView lbl_sign, lbl_skip;

    private TextInputEditText userNameEditText , passwordEditText , storeNameText;

    private Button signIn_button;

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
        if (signIn_button.getText().equals(getText(R.string.sign_next))) {
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



    private void postApiCall_Signin(){

        Map<String, String> params = new HashMap<>();
        params.put("email",userNameEditText.getText().toString());
        params.put("password", passwordEditText.getText().toString());

        APIManager.postWithResponse( com.android.volley.Request.Method.POST , this , params, "moblogin",
                new IVolleyCallback() {
                    @Override
                    public void onSuccessResponse(JSONObject response) {
                        Log.d("maizer ","111"+response);
//                        callback.onSuccessResponse(response);
                    }

                    @Override
                    public void onErrorResponse(VolleyError e) {
                        Log.d("maizer","111 "+e.getMessage());
                    }

                });


//
//
//
//
//        params.put("login_type","1");
////
//        APIManager.onAPIConnectionResponse("moblogin", params, this, APIManager.APIMethod.POST, new APIResponse() {
//            @Override
//            public void onEventCallBack(JSONObject obj, int ret) {
//                try {
//                    Log.d("maizer ",""+obj);
//                    if (ret == 1) {
//                        JSONObject response = obj.getJSONObject("data");
////                        Myapplication.User_id = response.getString("Id");
//
//                        // @TODO             SharedPreferences.Editor editor = getSharedPreferences(MY_PREFS_NAME, MODE_PRIVATE).edit();
//                        // @TODO             editor.putString("email", user_name.getText().toString());
//                        // @TODO             editor.putString("password", user_pass.getText().toString());
//                        // @TODO            editor.apply();
//                        AppUtils.showOtherActivity(SignActivity.this, ControlActivity.class, -1);
//
//                    } else {
//                   RequestQueueService.showAlert("access failed!", SignActivity.this);
//                    }
//                } catch (JSONException e) {
//            // @TODO                     Toast.makeText(LoginActivity.this, e.toString(), Toast.LENGTH_SHORT).show();
//                    e.printStackTrace();
//                }
//            }
//        });


    }



    private void postApiCall_Register(){
        Map<String, String> params = new HashMap<>();
        params.put("name", storeNameText.getText().toString());
        params.put("email", userNameEditText.getText().toString());
        params.put("password", passwordEditText.getText().toString());
        params.put("device_type", "android");
        params.put("country_id", "8");
        params.put("country_name_ar", "Amman");
        params.put("country_name_en", "Amman");

        APIManager.onAPIConnectionResponse("mob-reg", params, this, APIManager.APIMethod.POST, new APIResponse() {
            @Override
            public void onEventCallBack(JSONObject obj, int ret) {
                if (ret == 1) {

                    // @TODO          startActivity(new Intent(SignActivity.this, LoginActivity.class));
                    // @TODO         SignActivity.this.finish();
                } else {
                    try {
                        String msg_ar = obj.getString("msg_ar");
                        String msg_en = obj.getString("msg_en");
                        RequestQueueService.showAlert(msg_en, SignActivity.this);

     // @TODO                        if (PersistentUser.isLanguage(mContext)) {
//                            RequestQueueService.showAlert(msg_en, SignActivity.this);
//                        } else {
//                            RequestQueueService.showAlert(msg_ar, SignActivity.this);
//                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                        RequestQueueService.showAlert(e.toString(), SignActivity.this);
                    }
                }
            }
        });
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

        signIn_button = findViewById(R.id.sign_button);
        lbl_skip = findViewById(R.id.lbl_sign_skip);

        img_back = findViewById(R.id.img_sign_back);

        otp_code = findViewById(R.id.otp_sign_code);


        userNameEditText = this.findViewById(R.id.phone_edit_text);
        passwordEditText = this.findViewById(R.id.password_edit_text);
        storeNameText  = this.findViewById(R.id.store_name_edit_text);

        userNameEditText.setText("admin@mateldajo.com");
        passwordEditText.setText("admin");
        signIn_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(isLogin) {
                    postApiCall_Signin();
                } else {
                    postApiCall_Register();
                }
            }
        });

        initWithLoginTab();

        initWithEvent();
    }

    private void initWithLoginTab() {
        llt_register_tab.setVisibility(View.GONE);
        if (isFirst) {
            llt_login_tab.setAlpha((float) 1.0);
            llt_register_tab.setAlpha((float) 0.0);
            llt_register_tab.setVisibility(View.GONE);
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

        signIn_button.setText(R.string.sign_signin);
        lbl_skip.setText(R.string.sign_entry);

        isLogin = true;
    }

    private void initWithRegisterTab() {
        llt_register_tab.setVisibility(View.VISIBLE);
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

        signIn_button.setText(R.string.sign_next);
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
