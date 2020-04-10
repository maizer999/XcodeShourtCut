package com.laodev.onepay.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.laodev.onepay.R;
import com.laodev.onepay.model.HistoryModel;
import com.laodev.onepay.model.ProductModel;

import java.util.List;

public class ProductAdapter extends BaseAdapter {

    private Context mContext;
    private List<ProductModel> mProducts;

    public ProductAdapter(Context context, List<ProductModel> products) {
        mProducts = products;
        mContext = context;
    }

    @Override
    public int getCount() {
        return mProducts.size();
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        convertView = LayoutInflater.from(mContext).inflate(R.layout.item_product, null);

        ProductModel model = mProducts.get(position);

        TextView lbl_price = convertView.findViewById(R.id.lbl_product_price);
        lbl_price.setText(model.price);
        TextView lbl_name = convertView.findViewById(R.id.lbl_product_name);
        lbl_name.setText(model.name);
        TextView lbl_count = convertView.findViewById(R.id.lbl_product_count);
        lbl_count.setText(model.count);
        TextView lbl_minus = convertView.findViewById(R.id.lbl_product_minuse);
        lbl_minus.setOnClickListener(v -> {
            int cnt = Integer.valueOf(model.count);
            if (cnt > 0) {
                cnt--;
                model.count = String.valueOf(cnt);
                notifyDataSetChanged();
            }
        });
        TextView lbl_plus = convertView.findViewById(R.id.lbl_product_plus);
        lbl_plus.setOnClickListener(v -> {
            int cnt = Integer.valueOf(model.count);
            cnt++;
            model.count = String.valueOf(cnt);
            notifyDataSetChanged();
        });

        return convertView;
    }


}
