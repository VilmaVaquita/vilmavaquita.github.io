var jaws = (function(jaws) {

  var pressed_keys = {}
  var previously_pressed_keys = {}
  var keyCodes = {"0":"48","1":"49","2":"50","3":"51","4":"52","5":"53","6":"54","7":"55","8":"56","9":"57","backspace":"8","tab":"9","enter":"13","shift":"16","ctrl":"17","alt":"18","pause":"19","caps_lock":"20","esc":"27","space":"32","page_up":"33","page_down":"34","end":"35","home":"36","left":"37","up":"38","right":"39","down":"40","insert":"45","delete":"46","a":"65","b":"66","c":"67","d":"68","e":"69","f":"70","g":"71","h":"72","i":"73","j":"74","k":"75","l":"76","m":"77","n":"78","o":"79","p":"80","q":"81","r":"82","s":"83","t":"84","u":"85","v":"86","w":"87","x":"88","y":"89","z":"90","windows_left":"91","windows_right":"92","select":"93","numpad0":"96","numpad1":"97","numpad2":"98","numpad3":"99","numpad4":"100","numpad5":"101","numpad6":"102","numpad7":"103","numpad8":"104","numpad9":"105","asterisk":"106","plus":"107","minus":"109","decimal_point":"110","divide":"111","f1":"112","f2":"113","f3":"114","f4":"115","f5":"116","f6":"117","f7":"118","f8":"119","f9":"120","numlock":"144","scrollock":"145","semicolon":"186","equals":"187","comma":"188","dash":"189","period":"190","slash":"191","grave_accent":"192","open_bracket":"219","backslash":"220","close_bracket":"221","single_quote":"222"};
  var keycodeNames = {"8":"backspace","9":"tab","13":"enter","16":"shift","17":"ctrl","18":"alt","19":"pause","20":"caps_lock","27":"esc","32":"space","33":"page_up","34":"page_down","35":"end","36":"home","37":"left","38":"up","39":"right","40":"down","45":"insert","46":"delete","48":"0","49":"1","50":"2","51":"3","52":"4","53":"5","54":"6","55":"7","56":"8","57":"9","65":"a","66":"b","67":"c","68":"d","69":"e","70":"f","71":"g","72":"h","73":"i","74":"j","75":"k","76":"l","77":"m","78":"n","79":"o","80":"p","81":"q","82":"r","83":"s","84":"t","85":"u","86":"v","87":"w","88":"x","89":"y","90":"z","91":"windows_left","92":"windows_right","93":"select","96":"numpad0","97":"numpad1","98":"numpad2","99":"numpad3","100":"numpad4","101":"numpad5","102":"numpad6","103":"numpad7","104":"numpad8","105":"numpad9","106":"asterisk","107":"plus","109":"minus","110":"decimal_point","111":"divide","112":"f1","113":"f2","114":"f3","115":"f4","116":"f5","117":"f6","118":"f7","119":"f8","120":"f9","144":"numlock","145":"scrollock","186":"semicolon","187":"equals","188":"comma","189":"dash","190":"period","191":"slash","192":"grave_accent","219":"open_bracket","220":"backslash","221":"close_bracket","222":"single_quote"};
  var on_keydown_callbacks = []
  var on_keyup_callbacks = []
  var mousebuttoncode_to_string = []
  var ie_mousebuttoncode_to_string = []
  var prevent_default_keys = []
 
/** @private
 * Map all javascript keycodes to easy-to-remember letters/words
 */
jaws.setupInput = function() {
  var m = []
  
  m[0] = "left_mouse_button"
  m[1] = "center_mouse_button"
  m[2] = "right_mouse_button"

  var ie_m = [];
  ie_m[1] = "left_mouse_button";
  ie_m[2] = "right_mouse_button";
  ie_m[4] = "center_mouse_button"; 
  
  mousebuttoncode_to_string = m
  ie_mousebuttoncode_to_string = ie_m;

  window.addEventListener("keydown", handleKeyDown);
  window.addEventListener("keyup", handleKeyUp);

  var jawswindow = jaws.canvas || jaws.dom
  jawswindow.addEventListener("mousedown", handleMouseDown, false);
  jawswindow.addEventListener("mouseup", handleMouseUp, false);
  jawswindow.addEventListener("touchstart", handleTouchStart, false);
  jawswindow.addEventListener("touchend", handleTouchEnd, false);

  window.addEventListener("blur", resetPressedKeys, false);

  // this turns off the right click context menu which screws up the mouseup event for button 2
  document.oncontextmenu = function() {return false};
}

/** @private
 * Reset input-hash. Called when game is blurred so a key-controlled player doesn't keep on moving when the game isn't focused.
 */
function resetPressedKeys(e) {
  for (var x in pressed_keys) {
    delete pressed_keys[x];
  }
}

/** @private
 * handle event "onkeydown" by remembering what key was pressed
 */
function handleKeyUp(e) {
  /* event = (e) ? e : window.event; */ /* Seems unnecessary because e is assumed to be non-null later */
  var code = code = e.keyCode;
  pressed_keys[code] = false;
  if (on_keyup_callbacks[code]) { 
    on_keyup_callbacks[code](code)
    e.preventDefault()
  } else if (prevent_default_keys[code]) {
    e.preventDefault();
  }
}

/** @private
 * handle event "onkeydown" by remembering what key was un-pressed
 */
function handleKeyDown(e) {
  /* event = (e) ? e : window.event; */ /* Seems unnecessary because e is assumed to be non-null later */
  var code = code = e.keyCode;
  pressed_keys[code] = true;
  if (on_keydown_callbacks[code]) { 
      on_keydown_callbacks[code](code);
      e.preventDefault();
  } else if (prevent_default_keys[code]) {
    e.preventDefault();
  }
}
/** @private
 * handle event "onmousedown" by remembering what button was pressed
 */
function handleMouseDown(e) {
  /* event = (e) ? e : window.event; */  /* Seems unnecessary because e is assumed to be non-null later */
  var human_name = mousebuttoncode_to_string[e.button]; // 0 1 2
  if (navigator.appName == "Microsoft Internet Explorer"){
	  human_name = ie_mousebuttoncode_to_string[e.button];
  }
  pressed_keys[human_name] = true
  if(on_keydown_callbacks[human_name]) { 
    on_keydown_callbacks[human_name](human_name);
    e.preventDefault();
  }
}


/** @private
 * handle event "onmouseup" by remembering what button was un-pressed
 */
function handleMouseUp(e) {
  /* event = (e) ? e : window.event; */  /* Seems unnecessary because e is assumed to be non-null later */
  var human_name = mousebuttoncode_to_string[e.button]  

  if (navigator.appName == "Microsoft Internet Explorer"){
	  human_name = ie_mousebuttoncode_to_string[e.button];
  }
  pressed_keys[human_name] = false;
  if(on_keyup_callbacks[human_name]) { 
    on_keyup_callbacks[human_name](human_name);
    e.preventDefault();
  }
}

/** @private
 * handle event "touchstart" by remembering what button was pressed
 */
function handleTouchStart(e) {
        /* event = (e) ? e : window.event; */  /* Seems unnecessary because e is assumed to be non-null later */
	pressed_keys["left_mouse_button"] = true
	jaws.mouse_x = e.touches[0].pageX - jaws.canvas.offsetLeft;
	jaws.mouse_y = e.touches[0].pageY - jaws.canvas.offsetTop;
	//e.preventDefault()
}

/** @private
 * handle event "touchend" by remembering what button was pressed
 */
function handleTouchEnd(e) {
  pressed_keys["left_mouse_button"] = false;
  jaws.mouse_x = undefined;
  jaws.mouse_y = undefined;
}

/** 
 * Prevents default browseraction for given keys.
 * @example
 * jaws.preventDefaultKeys( ["down"] )  // Stop down-arrow-key from scrolling page down
 */
jaws.preventDefaultKeys = function(array_of_strings) {
  var list = arguments;
  for(var i=0; i < list.length; i++) {
    prevent_default_keys[list[i]] = true;
  }
}

/**
 * Array: If a key is currently pressed, the value associated to the key is true, otherwise false or not present.
 */
jaws.pressed = pressed_keys;

/**
 * Mapping key names to codes, and vice-versa
 */
jaws.keyCodes = keyCodes;
jaws.keycodeNames = keycodeNames;

/** 
 * sets up a callback for a key (or array of keys) to call when it's pressed down
 * 
 * @example
 * // call goLeft() when left arrow key is  pressed
 * jaws.on_keypress(jaws.keyCode("left"), goLeft) 
 *
 * // call fireWeapon() when SPACE or CTRL is pressed
 * jaws.on_keypress([jaws.keyCodes["space"],jaws.keyCodes["ctrl"]], fireWeapon)
 */
jaws.on_keydown = function(key, callback) {
  if (jaws.isArray(key)) {
    for (var i=0; key[i]; i++) {
       on_keydown_callbacks[key[i]] = callback;
    }
  } else {
    on_keydown_callbacks[key] = callback;
  }
}

/** 
 * sets up a callback when a key (or array of keys) to call when it's released 
 */
jaws.on_keyup = function(key, callback) {
  if (jaws.isArray(key)) {
    for (var i=0; key[i]; i++) {
      on_keyup_callbacks[key[i]] = callback;
    }
  } else {
    on_keyup_callbacks[key] = callback;
  }
}

/** @private
 * Clean up all callbacks set by on_keydown / on_keyup 
 */
jaws.clearKeyCallbacks = function() {
  on_keyup_callbacks = [];
  on_keydown_callbacks = [];
}

return jaws;
})(jaws || {});
