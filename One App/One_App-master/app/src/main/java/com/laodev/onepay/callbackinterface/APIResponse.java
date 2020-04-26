package com.laodev.onepay.callbackinterface;

import org.json.JSONObject;

/**
 * Created by asus on 2016/8/28.
 */

public interface APIResponse {
    void onEventCallBack(JSONObject obj, int ret);
}
