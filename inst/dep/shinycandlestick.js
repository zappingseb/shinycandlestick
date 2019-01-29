// CandleStick Input Binding
//
// Definition of a Shiny InputBinding extension
//
// https://github.com/zappingseb/customshinyinput
// Author: Sebastian Wolf
// License: MIT

// -----------------------------------------------------

// Create a shiny input binding
// Each custom input needs to be a shiny input binding
// that is defined by the JavaScript class "Shiny" and
// using the method "InputBinding"
// The name can be chosen, here it is "CandleStickBinding"
var CandleStickBinding = new Shiny.InputBinding();

// Extend the binding with the functions seen here
$.extend(CandleStickBinding, {
  
  // The scope defines how the element is described in HTML code
  // The best way to find the scope 
  find: function(scope) {
    return $(scope).find(".shinycandlestick-wrapper");
  },
  getValue: function(el) {
    console.log($(el).find('input').val());
    return($(el).find('input').val());
  },
  setValue: function(el, value) {
   if(value=='on'){
     $(el).candlestick('on');
   }
   if(value=='off'){
     $(el).candlestick('off');
   }else{
     $(el).candlestick('default');
   }
  },
  subscribe: function(el, callback) {
    // the jQuery "change" function allows you
    // to notice any change to your input elements
   $(el).on('change.input',function(){
     console.log("change");
     callback(false);
       // When called with false, it will NOT use the rate policy,
	  // so changes will be sent immediately
   }); 
  },
  unsubscribe: function(el) {
    $(el).off('.shinycandlestick-wrapper');
  },
  getType: function(el) {
    return "CandleStickBinding";
 }
});

// Registering the shiny input
//
// The following function call is used to tell shiny that
// there now is a new Shiny.InputBinding that it shall
// deal with and that it's functionality can be found in
// the variable "CandleStickBinding"
Shiny.inputBindings.register(CandleStickBinding);