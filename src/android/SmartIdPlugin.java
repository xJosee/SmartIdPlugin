package com.develsystems.smartidplugin;

import android.content.Context;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import com.develsystems.smartid.models.Operation;
import com.develsystems.smartid.SmartId;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.*;

/**
 * This class echoes a string called from JavaScript.
 */
public class SmartIdPlugin extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("coolMethod")) {
            String message = args.getString(0);
            this.coolMethod(message, callbackContext);
            return true;
        }
        if (action.equals("initSmartId")) {
            String license = args.getString(0);
            String username = args.getString(1);
            Boolean isProduction = args.getBoolean(2);
            this.initSmartId(license, username, isProduction, callbackContext);
            return true;
        }
        if (action.equals("linkSmartId")) {
            String channel = args.getString(0);
            String session = args.getString(1);
            this.linkSmartId(channel, session, callbackContext);
            return true;
        }
        if (action.equals("unLinkSmartId")) {
            String channel = args.getString(0);
            String session = args.getString(1);
            this.unLinkSmartId(channel, session, callbackContext);
            return true;
        }
        if (action.equals("smartCoreOperation")) {
            String license = args.getString(0);
            String operation = args.getString(1);
            Boolean isProduction = args.getBoolean(2);
            this.smartCoreOperation(license, operation, isProduction, callbackContext);
            return true;
        }
        if (action.equals("startSmartId")) {
            this.startSmartId(callbackContext);
            return true;
        }
        return false;
    }

    private void initSmartId(String license, String username, Boolean isProduction, CallbackContext callbackContext){
        Context context = this.cordova.getActivity().getApplicationContext();

        if (license != null && license.length() > 0 && username != null && username.length() > 0) {
            SmartId.initInstance(
                context,
                license,
                username,
                isProduction
            );
            callbackContext.success("initSmartId method successful.");
        } else {
            callbackContext.error("Expected non-empty string argument.");
        }
    }

    private void linkSmartId(String channel, String session, CallbackContext callbackContext){
        if (channel != null && channel.length() > 0 && session != null && session.length() > 0) {
            SmartId.getInstance().Link(
                channel,
                session
            );
            callbackContext.success("linkSmartId method successful.");
        } else {
            callbackContext.error("Expected non-empty string argument.");
        }
    }

    private void unLinkSmartId(String channel, String session, CallbackContext callbackContext){
        if (channel != null && channel.length() > 0 && session != null && session.length() > 0) {
            SmartId.getInstance().UnLink(
                channel,
                session
            );
            callbackContext.success("unLinkSmartId method successful.");
        } else {
            callbackContext.error("Expected non-empty string argument.");
        }
    }

    private void smartCoreOperation(String license, String operation, Boolean isProduction, CallbackContext callbackContext){
        Context context = this.cordova.getActivity().getApplicationContext();

        if (license != null && license.length() > 0 && operation != null && operation.length() > 0) {
            ObjectMapper mapper = new ObjectMapper();
            try{
                SmartId.getInstance().CreateOperation(
                        context,
                        license,
                        mapper.readValue(operation , Operation.class),
                        isProduction
                );
            }catch (Exception e){
                callbackContext.error("smartCoreOperation method failed.");    
            }
        } else {
            callbackContext.error("Expected non-empty string argument.");
        }
    }

    private void startSmartId(CallbackContext callbackContext) {
        callbackContext.success("");
    }

    private void coolMethod(String message, CallbackContext callbackContext) {
        if (message != null && message.length() > 0) {
            callbackContext.success(message);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }
}
