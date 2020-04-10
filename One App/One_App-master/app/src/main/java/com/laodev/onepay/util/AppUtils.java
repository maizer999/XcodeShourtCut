package com.laodev.onepay.util;

import android.app.ActivityOptions;
import android.content.Intent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;

import androidx.appcompat.app.AppCompatActivity;

import com.laodev.onepay.R;

public class AppUtils {

    public static void showOtherActivity (AppCompatActivity activity, Class<?> cls, int direction) {
        Intent myIntent = new Intent(activity, cls);
        ActivityOptions options;
        switch (direction) {
            case 0:
                options = ActivityOptions.makeCustomAnimation(activity, R.anim.slide_in_right, R.anim.slide_out_left);
                activity.startActivity(myIntent, options.toBundle());
                break;
            case 1:
                options = ActivityOptions.makeCustomAnimation(activity, R.anim.slide_in_left, R.anim.slide_out_right);
                activity.startActivity(myIntent, options.toBundle());
                break;
            default:
                activity.startActivity(myIntent);
                break;
        }
    }

    public static void hideKeyboard(AppCompatActivity activity) {
        InputMethodManager imm = (InputMethodManager) activity.getSystemService(AppCompatActivity.INPUT_METHOD_SERVICE);
        View view = activity.getCurrentFocus();
        if (view == null) {
            view = new View(activity);
        }
        assert imm != null;
        imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
    }

}
