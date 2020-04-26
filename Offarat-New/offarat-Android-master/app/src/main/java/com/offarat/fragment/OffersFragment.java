package com.offarat.fragment;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.offarat.BaseActivity;
import com.offarat.R;
import com.offarat.adapter.FavouriteAdapter;
import com.offarat.callbackinterface.APIResponse;
import com.offarat.callbackinterface.FilterItemCallback;
import com.offarat.callbackinterface.SearchInterface;
import com.offarat.customview.VerticalSpaceItemDecoration;
import com.offarat.model.Offer;
import com.offarat.model.Store;
import com.offarat.myapplication.Myapplication;
import com.offarat.volley.APIManager;
import com.offarat.volley.RequestQueueService;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class OffersFragment extends Fragment {

    private BaseActivity mActivity;

    private FavouriteAdapter mFavouriteAdapter;
    private ArrayList<Offer> allItemList= new ArrayList<>();

    public OffersFragment(BaseActivity activity) {
        mActivity = activity;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_offer, container, false);
        initUi(view);

        mActivity.setSearchCallBack(new SearchInterface(){
            @Override
            public void onSearchText(String searchText) {

            }

            @Override
            public void onBackPressButton() {
                Log.d("maizer","OffersFragment   : onBackPressButton");
                mActivity.onShowBrowseList(R.id.action_home);
            }
        });

        return view;
    }

    private void initUi(View view) {
        LinearLayoutManager mLinearLayoutManager = new LinearLayoutManager(getActivity(), LinearLayoutManager.VERTICAL, false);

        mFavouriteAdapter = new FavouriteAdapter(getActivity(), allItemList);
        mFavouriteAdapter.setOnFilterItemCallback(lFilterItemCallback);
        RecyclerView recyclerview_product = view.findViewById(R.id.ryc_offer_list);
        recyclerview_product.setLayoutManager(mLinearLayoutManager);
        recyclerview_product.addItemDecoration(new VerticalSpaceItemDecoration(10));
        recyclerview_product.setAdapter(mFavouriteAdapter);

        view.findViewById(R.id.BackButton).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mActivity.onShowBrowseList(R.id.action_home);
            }
        });

        get_offers();
    }

    public FilterItemCallback lFilterItemCallback = new FilterItemCallback() {
        @Override
        public void onClickFilterItemCallback(int type, Offer offer) {
            Myapplication.selected_offer = offer;
            mActivity.onShowOfferDetail(offer, R.id.action_home);
        }

        @Override
        public void onClickStoreItemCallback(int type, Store store) {
            //
        }

        @Override
        public void onClickCompanyNameCallback(Offer offer) {
            mActivity.onClickCompanyNameCallback(offer);
        }
    };

    private void get_offers(){
        Map<String, String> params = new HashMap<>();
        params.put("user_id", Myapplication.User_id);
        params.put("category_id", Myapplication.categoryID);
//        params.put("sub_cat_id", Myapplication.subcategoryID);

        APIManager.onAPIConnectionResponse("mobgetOfferCategory", params, getActivity(), APIManager.APIMethod.POST, new APIResponse() {
            @Override
            public void onEventCallBack(JSONObject obj, int ret) {
                try {
                    if (ret == 1) {
                        allItemList.clear();

                        JSONArray jsonArray = obj.getJSONArray("data");
                        if (jsonArray.length() > 0) {
                            for (int i = 0; i < jsonArray.length(); i++) {
                                JSONObject object = (JSONObject) jsonArray.get(i);
                                Offer offer = new Offer();
                                offer.initWithJson(object);
                                allItemList.add(offer);
                            }
                        }
                        mFavouriteAdapter.notifyDataSetChanged();
                    } else {
                        RequestQueueService.showAlert("access failed!", getActivity());
                    }
                } catch (JSONException e) {
                    Toast.makeText(getContext(), e.toString(), Toast.LENGTH_SHORT).show();
                    e.printStackTrace();
                }
            }
        });
    }

}
