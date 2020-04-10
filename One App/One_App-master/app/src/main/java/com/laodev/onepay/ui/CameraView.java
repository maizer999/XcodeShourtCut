package com.laodev.onepay.ui;

import android.app.Activity;
import android.content.Context;
import android.hardware.Camera;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

import java.io.IOException;

public class CameraView extends SurfaceView implements SurfaceHolder.Callback{
    private Camera camera;

    public CameraView(Context context) {
        super(context);
        getHolder().addCallback(this);
        getHolder().setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
    }


    public static void setCameraDisplayOrientation(Activity activity, int cameraId, Camera camera){
        Camera.CameraInfo info = new Camera.CameraInfo();
        Camera.getCameraInfo(cameraId, info);
        int rotation = activity.getWindowManager().getDefaultDisplay().getRotation();
        int degrees = 0;
        switch (rotation){
            case Surface.ROTATION_0:
                degrees = 0;
                break;
            case Surface.ROTATION_90:
                degrees = 90;
                break;
            case Surface.ROTATION_180:
                degrees = 180;
                break;
            case Surface.ROTATION_270:
                degrees = 270;
                break;
        }

        int result;
        if (info.facing == Camera.CameraInfo.CAMERA_FACING_FRONT){
            result = (info.orientation + degrees) % 360;
            result = (360 - result) % 360;
        }else{
            result = (info.orientation - degrees + 360) % 360;
        }

        camera.setDisplayOrientation(result);

    }

    @Override
    public void surfaceCreated(SurfaceHolder surfaceHolder) {
        camera = Camera.open();
    }

    @Override
    public void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i1, int i2) {
        setCameraDisplayOrientation((Activity)getContext(), Camera.CameraInfo.CAMERA_FACING_BACK, camera);
        Camera.Parameters parameters = camera.getParameters();
        Camera.Size bestSize = null;
        for (Camera.Size size : parameters.getSupportedPictureSizes()){
            if (size.width <= i1 && size.height <=i2) {
                if (bestSize == null) {
                    bestSize = size;
                } else {
                    int bestArea = bestSize.width * bestSize.height;
                    int newArea = size.width * size.height;

                    if (newArea > bestArea){
                        bestSize = size;
                    }
                }
            }
        }

        parameters.setPictureSize(bestSize.width, bestSize.height);
        parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_CONTINUOUS_PICTURE);
        camera.setParameters(parameters);

        try{
            camera.setPreviewDisplay(surfaceHolder);
        }catch (IOException e){
            e.printStackTrace();
        }

        camera.startPreview();


    }

    @Override
    public void surfaceDestroyed(SurfaceHolder surfaceHolder) {
        camera.stopPreview();
        camera.release();
        camera = null;
    }


}