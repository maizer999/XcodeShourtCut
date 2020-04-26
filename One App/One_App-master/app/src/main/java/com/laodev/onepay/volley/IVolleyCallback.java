package com.laodev.onepay.volley;

import com.android.volley.VolleyError;

import org.json.JSONObject;

/**
 * Created by Mohammad Abu Maizer on 16/4/2020.
 */

public interface IVolleyCallback {
    void onSuccessResponse(JSONObject result);

    void onErrorResponse(VolleyError e);
}
