/*
    A (haxelib)spritesheet parser for TexturePacker json export.
    I think it works with Flash cs5/6 export of spritesheets as json as well?

    NOTE: This has an additional json description required as well as the spritesheet description,
    which defines the animation behaviors for the sprite.trace

    MIT licenced, Based on some code from the nme community (still finding source link..)
*/

package com.underscorediscovery;

import com.eclecticdesignstudio.spritesheet.data.SpriteSheetFrame;
import com.eclecticdesignstudio.spritesheet.SpriteSheet;
import com.eclecticdesignstudio.spritesheet.data.BehaviorData;

import hxjson2.JSON;

class TexturePackerJSON {

        //data              : The JSON string to parse of the spritesheet
        //data2             : The Behaviors json file to describe the animations
        //assetDirectory    : Self explained, where to look relative for images
        //name              : The name of the sprite sheet returned
    public static function parse(data:String, data2:String, assetDirectory:String="", name:String=""):SpriteSheet {

            //Don't allow null data
        if(data == null) {
            return null;
        }

            //The json for the spritesheet
        var json:Dynamic = hxjson2.JSON.parse(data);
            //The behavior json
        var bjson:Dynamic = hxjson2.JSON.parse(data2);

            //The frames of the spritesheet
        var frames:Array<SpriteSheetFrame> = new Array<SpriteSheetFrame>();
            //The list of behaviors for the spritesheet
        var behaviors:Hash<BehaviorData> = new Hash<BehaviorData>();
            //The list of frames for the behaviors
        var behaviorFrames:Array<Int> = new Array<Int>();
                
            //If no name is assigned, use the image name
        if (name == "") name = json.meta.image;
        
            //Start the generation of the spritesheet
        var fields = Reflect.fields(json.frames);

            //We want to sort these by name, because the frames images are usually sequenced.        
        fields.sort( function(f:String, a:String):Int{
            if(f < a) return -1;
            if(f > a) return 1;            
            return 0;
        });

            //Now parse all the frames and add them to the full list
        for (prop in fields) {

            var frame = Reflect.field(json.frames, prop);

            frames.push(    
                new SpriteSheetFrame(
                    Std.parseInt(frame.frame.x),
                    Std.parseInt(frame.frame.y), 
                    Std.parseInt(frame.frame.w), 
                    Std.parseInt(frame.frame.h), 
                    Std.parseInt(frame.spriteSourceSize.x), 
                    Std.parseInt(frame.spriteSourceSize.y)
                ) //spriteSheetFrame
            ); //push

        }

            //Now parse the behavior information, adding each behavior we find in the json
        var bfields = Reflect.fields(bjson);
        var count : Int = 0;

        for (prop in bfields) {

            var frame = Reflect.field(bjson, prop);
            var framelist : Array<Int>;
            framelist = frame.frames;

            var finalframelist : Array<Int> = new Array<Int>();
            for(f in framelist) {
                finalframelist.push(f-1);
            }
                //Create the beahviordata for the SpriteSheet
            var behaviorData : BehaviorData = new BehaviorData(prop, finalframelist, frame.loop, frame.speed, 0, 0);
                //Store the behavior based on the name in the json
            behaviors.set(prop, behaviorData);
            
        }   

            //Finally, create the spritesheet        
        var spritesheet:SpriteSheet = new SpriteSheet(frames, behaviors);
            //assign the details
        spritesheet.name = name;
            //Set the image file from the json descriptions
        spritesheet.setImage(ApplicationMain.getAsset(assetDirectory + '/' + json.meta.image));

            //And done.
        return spritesheet;
        
    } //parse

} //TexturePackerJSON