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

import java.util.List;

public class HistoryAdapter extends BaseAdapter {

    private Context mContext;
    private List<HistoryModel> mHistories;

    private HistoryAdapterCallback mCallback;

    public HistoryAdapter(Context context, List<HistoryModel> histories, HistoryAdapterCallback callback) {
        mHistories = histories;
        mContext = context;
        mCallback = callback;
    }

    @Override
    public int getCount() {
        return mHistories.size();
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

        convertView = LayoutInflater.from(mContext).inflate(R.layout.item_history, null);

        HistoryModel model = mHistories.get(position);

        TextView lbl_price = convertView.findViewById(R.id.lbl_history_price);
        lbl_price.setText(model.price);
        TextView lbl_time = convertView.findViewById(R.id.lbl_history_time);
        lbl_time.setText(model.time_hour + "\n" + model.time_date);
        ImageView img_delete = convertView.findViewById(R.id.img_history_delete);
        img_delete.setOnClickListener(v -> mCallback.onClickDeleteBtn());

        return convertView;
    }

    public interface HistoryAdapterCallback {
        void onClickDeleteBtn();
    }

}
