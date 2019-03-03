Stopwatch = function ()  {};
Stopwatch.prototype = {
   startTime: 0,
   running: false,
   elapsed: undefined,
   start: function () {
      this.startTime = +new Date();
      this.elapsedTime = undefined;
      this.running = true;
   },
   stop: function () {
      this.elapsed = (+new Date()) - this.startTime;
      this.running = false;
   },
   getElapsedTime: function () {
      if (this.running) {
         return (+new Date()) - this.startTime;
      }
      else {
        return this.elapsed;
      }
   },
   isRunning: function() {
      return this.running;
   },
   reset: function() {
     this.elapsed = 0;
   }
};

AnimationTimer = function (duration, timeWarp)  {
   this.timeWarp = timeWarp;
   if (duration !== undefined)
    this.duration = duration;
   else
    this.duration = 1000;
   this.stopwatch = new Stopwatch();
};

AnimationTimer.prototype = {
   start: function () {
      this.stopwatch.start();
   },
   stop: function () {
      this.stopwatch.stop();
   },
   getRealElapsedTime: function () {
      return this.stopwatch.getElapsedTime();
   },
   getElapsedTime: function () {
      var elapsedTime = this.stopwatch.getElapsedTime(),
          percentComplete = elapsedTime / this.duration;
      if (!this.stopwatch.running)    return undefined;
      if (this.timeWarp == undefined) return elapsedTime;
      return elapsedTime * (this.timeWarp(percentComplete) / percentComplete);
   },
   isRunning: function() {
      return this.stopwatch.running;
   },
   isOver: function () {
      return this.stopwatch.getElapsedTime() > this.duration;
   },
   reset: function() {
      this.stopwatch.reset();
   }
};

AnimationTimer.makeEaseOut = function (strength) {
   return function (percentComplete) {
      return 1 - Math.pow(1 - percentComplete, strength*2);
   };
};

AnimationTimer.makeEaseIn = function (strength) {
   return function (percentComplete) {
      return Math.pow(percentComplete, strength*2);
   };
};

AnimationTimer.makeEaseInOut = function () {
   return function (percentComplete) {
      return percentComplete - Math.sin(percentComplete*2*Math.PI) / (2*Math.PI);
   };
};

AnimationTimer.makeElastic = function (passes) {
   passes = passes || 3;
   return function (percentComplete) {
       return ((1-Math.cos(percentComplete * Math.PI * passes)) *
               (1 - percentComplete)) + percentComplete;
   };
};

AnimationTimer.makeBounce = function (bounces) {
   var fn = AnimationTimer.makeElastic(bounces);
   return function (percentComplete) {
      percentComplete = fn(percentComplete);
      return percentComplete <= 1 ? percentComplete : 2-percentComplete;
   };
};

AnimationTimer.makeLinear = function () {
   return function (percentComplete) {
      return percentComplete;
   };
};

var ImagePainter = function (imageUrl) {
   this.image = new Image;
   this.image.src = imageUrl;
};

ImagePainter.prototype = {
   image: undefined,
   paint: function (sprite, context) {
      if (this.image !== undefined) {
         if ( ! this.image.complete) {
            this.image.onload = function (e) {
               sprite.width = this.width;
               sprite.height = this.height;

               context.drawImage(this,  // this is image
                  sprite.left, sprite.top,
                  sprite.width, sprite.height);
            };
         }
         else {
           context.drawImage(this.image, sprite.left, sprite.top,
                             sprite.width, sprite.height);
         }
      }
   }
};

SpriteSheetPainter = function (cells) {
   this.cells = cells;
};

SpriteSheetPainter.prototype = {
   cells: [],
   cellIndex: 0,
   advance: function () {
      if (this.cellIndex == this.cells.length-1)
         this.cellIndex = 0;
      else
         this.cellIndex++;
   },
   paint: function (sprite, context) {
      var cell = this.cells[this.cellIndex];
      context.drawImage(spritesheet, cell.left, cell.top,
                                     cell.width, cell.height,
                                     sprite.left, sprite.top,
                                     cell.width, cell.height);
   }
};

var SpriteAnimator = function (painters, elapsedCallback) {
   this.painters = painters;
   if (elapsedCallback)
      this.elapsedCallback = elapsedCallback;
};

SpriteAnimator.prototype = {
   painters: [],
   duration: 1000,
   startTime: 0,
   index: 0,
   elapsedCallback: undefined,
   end: function (sprite, originalPainter) {
      sprite.animating = false;
      if (this.elapsedCallback)
         this.elapsedCallback(sprite);
      else
         sprite.painter = originalPainter;
   },
   start: function (sprite, duration) {
      var endTime = +new Date() + duration,
          period = duration / (this.painters.length),
          interval = undefined,
          animator = this, // for setInterval() function
          originalPainter = sprite.painter;
      this.index = 0;
      sprite.animating = true;
      sprite.painter = this.painters[this.index];
      interval = setInterval(function() {
         if (+new Date() < endTime)
            sprite.painter = animator.painters[++animator.index];
         else {
            animator.end(sprite, originalPainter);
            clearInterval(interval);
         }
      }, period);
   },
};

var Sprite = function (name, painter, behaviors) {
   if (name !== undefined)
    this.name = name;
   if (painter !== undefined)
    this.painter = painter;
   if (behaviors !== undefined)
    this.behaviors = behaviors;
   return this;
};

Sprite.prototype = {
   left: 0,
   top: 0,
   width: 10,
   height: 10,
	 velocityX: 0,
	 velocityY: 0,
   visible: true,
   animating: false,
   painter: undefined, // object with paint(sprite, context)
   behaviors: [], // objects with execute(sprite, context, time)
	paint: function (context) {
     if (this.painter !== undefined && this.visible) {
        this.painter.paint(this, context);
     }
	},
   update: function (context, time) {
      for (var i = this.behaviors.length; i > 0; --i) {
         this.behaviors[i-1].execute(this, context, time);
      }
   }
};

window.requestNextAnimationFrame =
   (function () {
      var originalWebkitRequestAnimationFrame = undefined,
          wrapper = undefined,
          callback = undefined,
          geckoVersion = 0,
          userAgent = navigator.userAgent,
          index = 0,
          self = this;
      if (window.webkitRequestAnimationFrame) {
         wrapper = function (time) {
           if (time === undefined)
              time = +new Date();
           self.callback(time);
         };
         originalWebkitRequestAnimationFrame = window.webkitRequestAnimationFrame;
         window.webkitRequestAnimationFrame = function (callback, element) {
            self.callback = callback;
            originalWebkitRequestAnimationFrame(wrapper, element);
         }
      }

      if (window.mozRequestAnimationFrame) {
         index = userAgent.indexOf('rv:');
         if (userAgent.indexOf('Gecko') != -1) {
            geckoVersion = userAgent.substr(index + 3, 3);
            if (geckoVersion === '2.0')
               window.mozRequestAnimationFrame = undefined;
         }
      }

      return window.requestAnimationFrame   ||
         window.webkitRequestAnimationFrame ||
         window.mozRequestAnimationFrame    ||
         window.oRequestAnimationFrame      ||
         window.msRequestAnimationFrame     ||

         function (callback, element) {
            var start, finish;
            window.setTimeout( function () {
               start = +new Date();
               callback(start);
               finish = +new Date();
               self.timeout = 1000 / 60 - (finish - start);
            }, self.timeout);
         };
      }
   )
();

window.onload = function()
{
var canvas = document.getElementById("canvas"),
    context = canvas.getContext('2d'),
		treeImage = new Image(),
    RIGHT = 1,
    LEFT = 2,
    BALL_RADIUS = 23,
		LEAF_HEIGHT = 30,
    GRAVITY_FORCE = 9.81,  // 9.81 m/s / s
    lastTime = 0,
		LEAF_ANIMATION_TIME = 2,
		LEAF_ROTATION_ANGLE = Math.PI / 30,
    fps = 60,
    PLATFORM_HEIGHT_IN_METERS = 15, // 10 meters
    pixelsPerMeter = (canvas.height) / PLATFORM_HEIGHT_IN_METERS,

    moveLeaf = {
      lastFrameTime: undefined,

      execute: function (sprite, context, time) {
         var now = +new Date();
         if (this.lastFrameTime == undefined) {
            this.lastFrameTime = now;
            return;
         }
				 if (!sprite.rotationTimer.isRunning() ) {
					 if (sprite.animationTimer.getElapsedTime() >= sprite.rotatingBegin)
					      sprite.rotationTimer.start();
				 }

         if (sprite.animating) {
            if (sprite.pushDirection === LEFT)
              sprite.left -= sprite.velocityX / fps;
            else
              sprite.left += sprite.velocityX / fps;
            sprite.top += sprite.velocityY / fps;
            sprite.velocityY = GRAVITY_FORCE *
               (sprite.animationTimer.getElapsedTime()/1000) * pixelsPerMeter;
            if (sprite.top > canvas.height) {
							 sprite.animationTimer.stop();
							 sprite.animating = false;
							 sprite.velocityY = 0;
            }
         }
      }
    },
		leaves = new Array();

function paintLeaf(sprite, context) {
	context.save();
	context.beginPath();
	if (sprite.rotationTimer.isRunning() ) {
		context.arc(sprite.left + LEAF_HEIGHT, sprite.top + LEAF_HEIGHT, LEAF_HEIGHT, sprite.rotationAngle, sprite.rotationAngle + Math.PI/2, false);
		if (sprite.rotationClockwise)
		  sprite.rotationAngle += LEAF_ROTATION_ANGLE; //Math.PI/30;
		else
		  sprite.rotationAngle -= LEAF_ROTATION_ANGLE; //Math.PI/30;
	}
  else
		context.arc(sprite.left + LEAF_HEIGHT, sprite.top + LEAF_HEIGHT, LEAF_HEIGHT, 0, Math.PI/2, false);
	context.closePath();
	context.clip();
	context.shadowColor = 'rgba(0,0,100,0.8)';
	context.fillStyle = 'rgba(211,102,23,0.95)';
  context.strokeStyle = 'rgba(238,236,0,1.0)';
  context.shadowOffsetX = -2;
	context.shadowOffsetY = -2;
	context.shadowBlur = 8;
	context.lineWidth = 2;
	context.fill();
	context.stroke();
	context.restore();
}

function calculateFps(time) {
   var fps = 1000 / (time - lastTime);
   lastTime = time;
   return fps;
}

function animate(time) {
   fps = calculateFps(time);
   context.clearRect(0,0,canvas.width,canvas.height);
	 for( var i = 0; i < leaves.length; i++ ) {
		 var leaf = leaves[i];
		 if (!leaf.animating)
		   leaves.splice( i, 1 ); //remove leaf from array if no longer animating
   }
	 for( var i = 0; i < leaves.length; i++ ) {
		 var leaf = leaves[i];
		 leaf.update(context, time);
	 }
	 for( var i = 0; i < leaves.length; i++ ) {
		 var leaf = leaves[i];
		 leaf.paint(context);
	  }
   window.requestNextAnimationFrame(animate);
}

function generateLeaf() {
  var leaf = new Sprite('leaf' + leaves.length,
       {
          paint: function (sprite, context) {
						 paintLeaf(sprite, context);
          }
       },
       [ moveLeaf ]
  );
	leaf.left = Math.floor( (Math.random() * canvas.width) + (LEAF_HEIGHT));
	leaf.top = 0;
	leaf.width = LEAF_HEIGHT;
	leaf.height = LEAF_HEIGHT;
	leaf.velocityX = 140;
	leaf.velocityY = 0;
  leaf['animationTimer'] = new AnimationTimer(LEAF_ANIMATION_TIME);
  leaf['rotationTimer'] = new AnimationTimer('2');
	var clockwise = true;
	if( ((Math.random() * 10) +1) > 5)
	  clockwise = false;
  leaf['rotationClockwise'] = clockwise;
  leaf['rotationAngle'] = 0;
	leaf['rotatingBegin'] = Math.floor( Math.random() * LEAF_ANIMATION_TIME ) * 1000;
	leaf.animationTimer.start();  //start the animation but not rotating
  leaf['pushDirection'] = Math.floor( (Math.random() * 2) + 1);
	leaf.animating = true;
	leaves.push(leaf);
}
window.requestNextAnimationFrame(animate);
setInterval( generateLeaf, 300);
}
