package com.example.light_weight_picker;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.provider.OpenableColumns;
import android.util.JsonWriter;
import android.webkit.MimeTypeMap;

import androidx.annotation.Nullable;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.IntBuffer;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.PluginRegistry;

/** LightWeightPickerPlugin */
public class LightWeightPickerPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private Activity activity;
  private Result result;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "light_weight_picker");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

 @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    this.result = result;
 if (call.method.equals("browseAndGetFile")) {
     JSONArray selectedTypes = getSelectedTypes(call.arguments);
     String[] mimeTypes = getPickerMimeTypes(selectedTypes);
      doBrowseFile(mimeTypes);
 }
  }




  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    binding.addActivityResultListener(this);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }


    private JSONArray getSelectedTypes(Object args){
        try {
            JSONObject jsonData = new JSONObject( args.toString());
            JSONArray array = jsonData.getJSONArray("fileTypes");
            return array;
        } catch (JSONException e) {
            e.printStackTrace();
            return new JSONArray();
        }
    }
    private String imageType = "image/*";
    private String audioType = "audio/*";
    private String videoType = "video/*";
    private String documentType = "application/*";

    private String[] getPickerMimeTypes(JSONArray array){
        int length = array.length();
        if(length == 0){
            return  new String[]{"*/*"};
        }
        String[] pickerMimeTypes = new String[length];
        for (int i = 0; i<length; i++){
            try {
                String type = array.getString(i);
                if(type.equals("Images")){
                    pickerMimeTypes[i] = imageType;
                }else if(type.equals( "Videos")){
                    pickerMimeTypes[i] = videoType;
                }else  if(type.equals( "Audios")){
                    pickerMimeTypes[i] = audioType;
                }else  if(type.equals("Documents")){
                    pickerMimeTypes[i] = documentType;
                }else  if(type.equals( "Jpg")){
                    pickerMimeTypes[i] = "image/jpeg";
                }else  if(type.equals( "Png")){
                    pickerMimeTypes[i] = "image/png";
                }else  if(type.equals("Pdf")){
                    pickerMimeTypes[i] = "application/pdf";
                }else  if(type.equals("All")){
                    pickerMimeTypes[i] = "*/*";
                }

            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return  pickerMimeTypes;
    }


    private void setIntentTypes(Intent intent, String[] mimeTypes){

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            intent.setType(mimeTypes.length == 1 ? mimeTypes[0] : "*/*");
            if (mimeTypes.length > 0) {
                intent.putExtra(Intent.EXTRA_MIME_TYPES, mimeTypes);
            }
        } else {
            String mimeTypesStr = "";
            for (String mimeType : mimeTypes) {
                mimeTypesStr += mimeType + "|";
            }
            intent.setType(mimeTypesStr.substring(0,mimeTypesStr.length() - 1));
        }
    }

    private void doBrowseFile(String[] mimeTypes)  {

        Intent chooseFileIntent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        setIntentTypes(chooseFileIntent, mimeTypes);

        // Only return URIs that can be opened with ContentResolver
        chooseFileIntent.addCategory(Intent.CATEGORY_OPENABLE);


        chooseFileIntent = Intent.createChooser(chooseFileIntent, "Choose a file");
        activity.startActivityForResult(chooseFileIntent, 100);
    }


    @Override
  public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
    if(data != null && requestCode == 100){
      Uri uri = data.getData();
      String fileExtension = getExtension(uri);
      String fileName = getFileName(uri);

      InputStream iStream = null;
      try {
        iStream = activity.getContentResolver().openInputStream(uri);
      } catch (FileNotFoundException e) {
        e.printStackTrace();
      }
      try {
        byte[] fileBytes = getBytes(iStream);

          JSONObject json = new JSONObject();

          json.put("fileExtension" , fileExtension) ;
          json.put("fileName" , fileName) ;

          if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
              String encodedString = Base64.getEncoder().encodeToString(fileBytes);
              json.put("fileBytes", encodedString);
          }
          result.success(json.toString());


      } catch (IOException e) {
        e.printStackTrace();
        result.equals("Error appear");
      } catch (JSONException e) {
          e.printStackTrace();
      }
    }
    return true;
  }


    public  String getExtension(Uri uri) {
        String extension;
        System.out.println(uri.getScheme());
        if (uri.getScheme().equals(ContentResolver.SCHEME_CONTENT)) {
            final MimeTypeMap mime = MimeTypeMap.getSingleton();
            extension = mime.getExtensionFromMimeType(this.context.getContentResolver().getType(uri));

        } else {
            //If scheme is a File
            //This will replace white spaces with %20 and also other special characters. This will avoid returning null values on file name with spaces and special characters.
            extension = MimeTypeMap.getFileExtensionFromUrl(Uri.fromFile(new File(uri.getPath())).toString());

        }

        return extension;
    }


    public String getFileName(Uri uri) {
        String result = null;
        if (uri.getScheme().equals("content")) {
            Cursor cursor = activity.getContentResolver().query(uri, null, null, null, null);
            try {
                if (cursor != null && cursor.moveToFirst()) {
                    result = cursor.getString(cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME));
                }
            } finally {
                cursor.close();
            }
        }
        if (result == null) {
            result = uri.getPath();
            int cut = result.lastIndexOf('/');
            if (cut != -1) {
                result = result.substring(cut + 1);
            }
        }
        return result;
    }

  public byte[] getBytes(InputStream inputStream) throws IOException {
    ByteArrayOutputStream byteBuffer = new ByteArrayOutputStream();
    int bufferSize = 1024;
    byte[] buffer = new byte[bufferSize];

    int len = 0;
    while ((len = inputStream.read(buffer)) != -1) {
      byteBuffer.write(buffer, 0, len);
    }
    return byteBuffer.toByteArray();
  }
}
