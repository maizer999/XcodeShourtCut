package com.laodev.onepay.volley;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.laodev.onepay.R;
import com.laodev.onepay.callbackinterface.APIResponse;
import com.zhy.http.okhttp.OkHttpUtils;
import com.zhy.http.okhttp.callback.StringCallback;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.util.Map;

//import utils.okhttp.OkHttpUtils;

public class APIManager {

    private static Context mCtx ;

    final static private String SERVER_URL = "https://oneapptech.net/back/";
    final static public String UPLOAD_URL = SERVER_URL + "uploads/";

    public enum APIMethod {
        GET, POST
    }



    public static void postWithResponse(int method, Context context, Map<String, String> params, String url,  final IVolleyCallback callback) {
//        String url = String.format("%1s%2s", APIMethodURLs.JSON_OBJECT_REQUEST_URL, methodName);

        mCtx = context ;

        Log.d("@maizer", "" + url);
        Log.d("@maizer", "" + params);

        RequestQueue queue = MySingleton.getInstance(mCtx).getRequestQueue();

        JsonObjectRequest strreq = new JsonObjectRequest(Request.Method.POST, SERVER_URL+url, new JSONObject(params), new Response.Listener<JSONObject>() {

            @Override
            public void onResponse(JSONObject Response) {

                callback.onSuccessResponse(Response);
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError e) {
                e.printStackTrace();
                Toast.makeText(mCtx, e + "error", Toast.LENGTH_LONG).show();
                callback.onSuccessResponse(null);
            }
        });

        strreq.setRetryPolicy(new DefaultRetryPolicy(
                7000000,
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));


        MySingleton.getInstance(mCtx).addToRequestQueue(strreq);
    }


    public static void getWithResponse(Map<String, String> params, String methodName, final IVolleyCallback callback) {
        String url = String.format(methodName);

        Log.d("@maizer", "" + url);
        Log.d("@maizer", "" + params);

        RequestQueue queue = MySingleton.getInstance(mCtx).getRequestQueue();

        JsonObjectRequest strreq = new JsonObjectRequest(Request.Method.GET, url, new JSONObject(params), new Response.Listener<JSONObject>() {


            @Override
            public void onResponse(JSONObject Response) {
                callback.onSuccessResponse(Response);

            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError e) {
                try {


                    if (e.networkResponse != null) {
                        String responseBody = new String(e.networkResponse.data, "utf-8");
                        JSONObject jsonObject = new JSONObject(responseBody);
                    }
                } catch (JSONException e1) {


                } catch (UnsupportedEncodingException error) {

                }


                e.printStackTrace();
                Toast.makeText(mCtx, e + "error", Toast.LENGTH_LONG).show();
                callback.onSuccessResponse(null);
            }
        });

        strreq.setRetryPolicy(new DefaultRetryPolicy(
                7000000,
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));

        MySingleton.getInstance(mCtx).addToRequestQueue(strreq);
    }











    public static void onAPIConnectionResponse (String url
            , Map<String, String> params
            , final Context context
            , APIMethod method
            , final APIResponse apiResponse)
    {
        final ProgressDialog dialog = ProgressDialog.show(context
                , ""
                , context.getString(R.string.progress_detail));

        String serverUrl = SERVER_URL + url;
        Log.d("maizer",""+serverUrl);
        Log.d("maizer",""+params);

        if (method == APIMethod.POST) {

            OkHttpUtils.post().url(serverUrl)
                    .params(params)
                    .build()
                    .execute(new StringCallback() {
                        @Override
                        public void onError(okhttp3.Call call, Exception e, int id) {
                            if (dialog != null) {
                                dialog.dismiss();
                            }
                            Log.d("maizer",""+e.getMessage());
                            Toast.makeText(context, R.string.alert_error_internet_detail, Toast.LENGTH_SHORT).show();
                        }

                        @Override
                        public void onResponse(String response, int id) {
                            if (dialog != null) {
                                dialog.dismiss();
                            }
                            try {
                                Log.d("maizer",""+response);

                                JSONObject obj = new JSONObject(response);
                                int ret = obj.getInt("status");
                                apiResponse.onEventCallBack(obj, ret);
                            } catch (JSONException e) {
                                Toast.makeText(context, R.string.alert_server_error_detail, Toast.LENGTH_SHORT).show();
                                e.printStackTrace();
                            }
                        }
                    });
        } else {
            OkHttpUtils.get().url(serverUrl)
                    .params(params)
                    .build()
                    .execute(new StringCallback() {
                        @Override
                        public void onError(okhttp3.Call call, Exception e, int id) {
                            if (dialog != null) {
                                dialog.dismiss();
                            }
                            Toast.makeText(context, R.string.alert_error_internet_detail, Toast.LENGTH_SHORT).show();
                        }

                        @Override
                        public void onResponse(String response, int id) {
                            if (dialog != null) {
                                dialog.dismiss();
                            }
                            try {
                                JSONObject obj = new JSONObject(response);
                                int ret = obj.getInt("status");
                                apiResponse.onEventCallBack(obj, ret);
                            } catch (JSONException e) {
                                Toast.makeText(context, R.string.alert_server_error_detail, Toast.LENGTH_SHORT).show();
                                e.printStackTrace();
                            }
                        }
                    });
        }
    }


}
