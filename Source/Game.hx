
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;

import nme.Assets;
import nme.Lib;

    //The importer for SpriteSheet
import com.underscorediscovery.TexturePackerJSON;
    //The SpriteSheet class
import com.eclecticdesignstudio.spritesheet.AnimatedSprite;

class Game extends Sprite {

    public var sprite : AnimatedSprite;

    public function new () {
        
        super ();
        addEventListener (Event.ADDED_TO_STAGE, construct );       

    } //new

    private function construct(event:Event) : Void {

            //remove ourselves from the added message
        removeEventListener(Event.ADDED_TO_STAGE, construct );

            //First fetch the JSON for the sprite and behaviors
        var sprite_json = ApplicationMain.getAsset( "assets/player.json" );
        var behavior_json = ApplicationMain.getAsset( "assets/player_behavior.json" );

            //Now create the sprite sheet
        var spriteSheet = TexturePackerJSON.parse ( sprite_json, behavior_json, "assets" );
            //cache
        // spriteSheet.generateBitmaps();

            //Now the sprite
        sprite = new AnimatedSprite (spriteSheet);

            //Center
        sprite.x = (stage.stageWidth/2) - 32;
        sprite.y = (stage.stageHeight/2) - 32;

            //Create a list of animations (can be fetched from JSON or spriteSheet)
        var anim_list = ["idle","walk","death"];
        var current_anim = 0;

            //Default to idle
        sprite.showBehavior ("idle");

            //Now set up a key to cycle animations
        stage.addEventListener( KeyboardEvent.KEY_UP, function(e) {
                //cycle to the next animation
            current_anim++;

                //wrap around to 0
            if(current_anim > anim_list.length-1) {
                current_anim = 0;
            }

                //for debugging
            trace(current_anim + ' ' + anim_list[current_anim]);

                //set animation to current one
            sprite.showBehavior( anim_list[current_anim] );
        });

            //Finally add to stage
        addChild(sprite);

            //And finally finally add an update loop
        addEventListener(Event.ENTER_FRAME, function(e){
            sprite.update(16);  //16 milliseconds delta time (don't hardcode :))
        });

    } //construct
   
    public static function main () {
        
        Lib.current.addChild(new Game());

    } //main
    
}
