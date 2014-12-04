package org.zamedev.lib;

import haxe.Json;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;

class UrlLoaderExt {
    private var urlLoader:URLLoader;
    private var onComplete:Void->Void;
    private var onError:Void->Void;

    public var data(get, never):String;

    public function new(onComplete:Void->Void, onError:Void->Void) {
        this.onComplete = onComplete;
        this.onError = onError;

        urlLoader = new URLLoader();
        urlLoader.dataFormat = URLLoaderDataFormat.TEXT;

        urlLoader.addEventListener(Event.COMPLETE, onLoaderComplete);
        urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
        urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderError);
    }

    public function load(urlRequest:URLRequest):Void {
        try {
            urlLoader.load(urlRequest);
        } catch (e:Dynamic) {
            trace(e);
            onLoaderError(null);
        }
    }

    private function onLoaderComplete(_):Void {
        urlLoader.removeEventListener(Event.COMPLETE, onLoaderComplete);
        urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
        urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderError);

        onComplete();
    }

    private function onLoaderError(_):Void {
        urlLoader.removeEventListener(Event.COMPLETE, onLoaderComplete);
        urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
        urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderError);

        onError();
    }

    @:noComplete
    private function get_data():String {
        return Std.string(urlLoader.data);
    }

    public static function createJsonRequest(url:String, data:Dynamic):URLRequest {
        var urlRequest = new URLRequest(url);
        urlRequest.method = URLRequestMethod.POST;
        // urlRequest.contentType = "application/json";
        urlRequest.data = Json.stringify(data);

        return urlRequest;
    }
}
