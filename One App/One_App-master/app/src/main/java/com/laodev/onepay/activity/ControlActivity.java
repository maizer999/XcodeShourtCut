package com.laodev.onepay.activity;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.laodev.onepay.R;
import com.laodev.onepay.adapter.HistoryAdapter;
import com.laodev.onepay.adapter.ProductAdapter;
import com.laodev.onepay.model.HistoryModel;
import com.laodev.onepay.model.ProductModel;
import com.laodev.onepay.util.AppUtils;
import com.laodev.onepay.util.LocaleHelper;

import java.util.ArrayList;
import java.util.List;

public class ControlActivity extends AppCompatActivity {

    private LinearLayout llt_history, llt_qr, llt_setting, llt_wrong;

    private ImageView img_history, img_qr, img_setting;

    private ListView lst_history;
    private HistoryAdapter historyAdapter;
    private List<HistoryModel> mHistories = new ArrayList<>();

    private LinearLayout llt_qr_photo, llt_qr_manual;
    private TextView lbl_qr_photo, lbl_qr_manual;
    private ListView lst_product;
    private ProductAdapter productAdapter;
    private List<ProductModel> mProducts = new ArrayList<>();
    private LinearLayout llt_photo, llt_manual;
//    private ZBarScannerView mScannerView;

    private LinearLayout llt_language;
    private ImageView img_language, img_lang_arabic, img_lang_english;
    private TextView lbl_lang;

    private HistoryAdapter.HistoryAdapterCallback historyAdapterCallback = new HistoryAdapter.HistoryAdapterCallback() {
        @Override
        public void onClickDeleteBtn() {
            //
        }
    };

    public void onClickLltWrong(View view) {
        llt_wrong.setVisibility(View.VISIBLE);
    }

    public void onClickLltSave(View view) {
        llt_wrong.setVisibility(View.GONE);
        AppUtils.hideKeyboard(this);
    }

    public void onClickLltWrongBack(View view) {
        llt_wrong.setVisibility(View.GONE);
        AppUtils.hideKeyboard(this);
    }

    // Setting Event
    public void onClickLltLanguage(View view) {
        if (llt_language.getVisibility() == View.VISIBLE) {
            llt_language.setVisibility(View.GONE);
            img_language.setImageResource(R.drawable.ic_right);
        } else {
            llt_language.setVisibility(View.VISIBLE);
            img_language.setImageResource(R.drawable.ic_down);
        }
    }

    public void onClickLltLangArabic(View view) {
        LocaleHelper.setLocale(this, "ar");

        Intent intent = getIntent();
        overridePendingTransition(0, 0);
        intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
        finish();

        overridePendingTransition(0, 0);
        intent.putExtra("issetting",1);
        startActivity(intent);
    }

    public void onClickLltLangEnglish(View view) {
        LocaleHelper.setLocale(this, "en");

        Intent intent = getIntent();
        overridePendingTransition(0, 0);
        intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
        finish();

        overridePendingTransition(0, 0);
        intent.putExtra("issetting",1);
        startActivity(intent);
    }

    private void initEvent() {
        img_history.setOnClickListener(v -> initWithHistoryView());

        img_qr.setOnClickListener(v -> initWithQRView());
        llt_qr_photo.setOnClickListener(v -> initWithQRPhotoView());
        llt_qr_manual.setOnClickListener(v -> initWithQRManualView());

        img_setting.setOnClickListener(v -> initWithSettingView());
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_control);

        // Change Status Bar Color
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            getWindow().setStatusBarColor(getColor(R.color.colorMainBlue));
        } else {
            getWindow().setStatusBarColor(getResources().getColor(R.color.colorMainBlue));
        }

        initUIView();
        initWithData();
        initEvent();
    }

    private void initWithData() {
        mHistories.clear();
        for (int i = 0; i < 20; i++) {
            HistoryModel model = new HistoryModel();
            model.id = String.valueOf(i);
            model.price = "21.50";
            model.time_hour = "8 Items - 2:08 PM";
            model.time_date = "8 Match 2020";

            mHistories.add(model);
        }
        historyAdapter.notifyDataSetChanged();

        mProducts.clear();
        for (int i = 0; i < 10; i++) {
            ProductModel model = new ProductModel();
            model.id = String.valueOf(i);
            model.name = "Product Name " + (i + 1);
            model.price = "1.50";
            model.count = "1";

            mProducts.add(model);
        }
        productAdapter.notifyDataSetChanged();
    }

    private void initUIView() {
        img_history = findViewById(R.id.img_control_history);
        img_qr = findViewById(R.id.img_control_qr);
        img_setting = findViewById(R.id.img_control_setting);

        llt_history = findViewById(R.id.llt_control_history);
        llt_qr = findViewById(R.id.llt_control_qr);
        llt_setting = findViewById(R.id.llt_control_setting);
        llt_wrong = findViewById(R.id.llt_control_wrong);

        lst_history = findViewById(R.id.lst_ctrl_history);
        historyAdapter = new HistoryAdapter(this, mHistories, historyAdapterCallback);
        lst_history.setAdapter(historyAdapter);

        llt_qr_photo = findViewById(R.id.llt_ctrl_qr_photo);
        llt_qr_manual = findViewById(R.id.llt_ctrl_qr_manual);
        lbl_qr_photo = findViewById(R.id.lbl_ctrl_qr_photo);
        lbl_qr_manual = findViewById(R.id.lbl_ctrl_qr_manual);
        lst_product = findViewById(R.id.lst_ctrl_product);
        productAdapter = new ProductAdapter(this, mProducts);
        lst_product.setAdapter(productAdapter);
        llt_photo = findViewById(R.id.llt_ctrl_photo);
        llt_manual = findViewById(R.id.llt_ctrl_manual);

        llt_language = findViewById(R.id.llt_ctrl_language);
        img_language = findViewById(R.id.img_ctrl_language);
        img_lang_arabic = findViewById(R.id.img_lang_arabic);
        img_lang_english = findViewById(R.id.img_lang_english);
        lbl_lang = findViewById(R.id.lbl_ctrl_lang);

        int is_setting = getIntent().getIntExtra("issetting", 0);
        if (is_setting == 0) {
            initWithHistoryView();
        } else {
            initWithSettingView();
            onClickLltLanguage(null);
        }
    }

    private void initWithHistoryView() {
        initDrawable();

        img_history.setImageResource(R.drawable.ic_history_blue);
        llt_history.setVisibility(View.VISIBLE);
    }

    private void initWithQRView() {
        initDrawable();

        img_qr.setImageResource(R.drawable.img_logo);
        llt_qr.setVisibility(View.VISIBLE);

        initWithQRPhotoView();
    }

    private void initWithQRPhotoView() {
        llt_photo.setVisibility(View.VISIBLE);
        llt_manual.setVisibility(View.GONE);

        llt_qr_photo.setBackgroundResource(R.drawable.llt_seg_left_fill);
        llt_qr_manual.setBackgroundResource(R.drawable.llt_seg_right);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            lbl_qr_photo.setTextColor(getColor(R.color.colorMainBlue));
        } else {
            lbl_qr_photo.setTextColor(getResources().getColor(R.color.colorMainBlue));
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            lbl_qr_manual.setTextColor(getColor(R.color.colorMainWhite));
        } else {
            lbl_qr_manual.setTextColor(getResources().getColor(R.color.colorMainWhite));
        }
    }

    private void initWithQRManualView() {
        llt_photo.setVisibility(View.GONE);
        llt_manual.setVisibility(View.VISIBLE);

        llt_qr_photo.setBackgroundResource(R.drawable.llt_seg_left);
        llt_qr_manual.setBackgroundResource(R.drawable.llt_seg_right_fill);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            lbl_qr_photo.setTextColor(getColor(R.color.colorMainWhite));
        } else {
            lbl_qr_photo.setTextColor(getResources().getColor(R.color.colorMainWhite));
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            lbl_qr_manual.setTextColor(getColor(R.color.colorMainBlue));
        } else {
            lbl_qr_manual.setTextColor(getResources().getColor(R.color.colorMainBlue));
        }
    }

    private void initWithSettingView() {
        initDrawable();

        img_setting.setImageResource(R.drawable.ic_setting_blue);
        llt_setting.setVisibility(View.VISIBLE);

        llt_language.setVisibility(View.GONE);
        img_language.setImageResource(R.drawable.ic_right);

        initShownLang();
    }

    private void initShownLang() {
        if (LocaleHelper.getLanguage(this).equals("ar")) {
            img_lang_arabic.setVisibility(View.VISIBLE);
            img_lang_english.setVisibility(View.GONE);
            lbl_lang.setText(R.string.ctrl_arabic);
        } else {
            img_lang_arabic.setVisibility(View.GONE);
            img_lang_english.setVisibility(View.VISIBLE);
            lbl_lang.setText(R.string.ctrl_english);
        }
    }

    private void initDrawable() {
        img_history.setImageResource(R.drawable.ic_history);
        img_qr.setImageResource(R.drawable.ic_qr);
        img_setting.setImageResource(R.drawable.ic_setting);

        llt_history.setVisibility(View.GONE);
        llt_qr.setVisibility(View.GONE);
        llt_setting.setVisibility(View.GONE);
        llt_wrong.setVisibility(View.GONE);
    }

    @Override
    public void onBackPressed() {
        llt_wrong.setVisibility(View.GONE);
    }


}
