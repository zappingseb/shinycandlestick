


#' Attach dependencies for candlestick
#' 
#' @description Adds the dependencies jquery, jquery hammer, hammer, candlestick and font-awesome
#'    to the candlestick
#' @param tag any shiny element
#' 
#' @export
#' @import htmltools
attachDependenciesCandleStick <- function(tag) {
  
  version <- as.character(utils::packageVersion("shinycandlestick")[[1]])
  dep <- htmltools::htmlDependency(
    name = "shinycandlestick", version = version,
    package = "shinycandlestick",
    src = "dep", # - Fix upon loading without devtools
    stylesheet = c("candlestick_extra.css","candlestick.map.css","candlestick.min.css"),
    script = c("candlestick.min.js","hammer.min.js","jquery.hammer.js","shinycandlestick.js"),
    head='<link href="https://use.fontawesome.com/releases/v5.0.1/css/all.css" rel="stylesheet">'
  )
  message(paste0("ATTACHED .js and .css dependencies from 'shinycandlestick' package."))
  
  htmltools::attachDependencies(tag, dep, append = TRUE)
  
}

#' CandleStick input with three options
#' 
#' This is an input taken from https://github.com/EdouardTack/candlestick
#' to allow a three item candlestick in shiny
#' 
#' @param candlestick_size Sizes (lg, md (default), sm, xs)
#' @param candlestick_mode 'option' or 'contents'
#' @param fa_mode \code{logical} Whether to use font-awesome icons, works
#'    just in 'contents' mode
#' @param left named vector with left option - name is the value
#' @param right named vector with right option - name value
#' @param default named vector with central option
#' @param id ID of the element
#' @param contents_color Color of the select element in case the 'contents' mode is used.
#' 
#' @references \link{registerCandleStick}, \link{attachDependenciesCandleStick},
#' 
#' @export
#' @import shiny
#' @importFrom glue glue
CandleStick <- function(id="fancycolorpicker",
                        left = c('f'='f182'),
                        right = c('m'='f183'),
                        default = c('b'='f22d'),
                        fa_mode = TRUE,
                        candlestick_mode = 'contents',
                        candlestick_size = 'md',
                        contents_color = '#fc4c02'
                        ){
  registerCandleStick()
  
  if(fa_mode && candlestick_mode=='contents'){
    left[1]    <- glue::glue("&#x{left[1]}")
    right[1]   <- glue::glue("&#x{right[1]}")
    default[1] <- glue::glue("&#x{default[1]}")
    fa <- 1
  }else{
    fa <- 0
  }
 
  # Return a div element of class "doubleclorpicker"
  tag <- div(
    id=id,
    class=paste0("shinycandlestick-wrapper ",ifelse(candlestick_mode=='contents','content','')),
    
    HTML(glue("<input type='checkbox' id='{id}-input' value='{names(default)}' name='{id}-input' class='js-candlestick'>")),
    
    # Include the Javascript code given by the https://github.com/EdouardTack/candlestick package
    # 
    # Used a trigger upon aftersetting to call the shiny subscribe function 
    HTML(
      glue::glue(
        "<script>
          $('#{id}-input').candlestick({{
            'mode':'{candlestick_mode}',
            'fa': {fa},
            'contents': {{ 
                    'left': '{left}',
                    'middle': '{default}', 
                    'right': '{right}', 
                    'swipe': true 
                }},
            'contents_color':'{contents_color}',
            'size':'{candlestick_size}',
            'on': '{names(right)}', 
            'off': '{names(left)}', 
            'nc': '{names(default)}',
            afterSetting: function(input, wrapper, value) {{
                    console.log($(input).attr('id'));
                    console.log(value);
                    $(input).trigger('change');
            }}
          }});
          </script>"
      )
    )# HTML
  )#div
  
  return(attachDependenciesCandleStick(tag))
}

#' Register a shiny candlestick
#' 
#' @export
#' 
#' Registrering the CandleStickBinding inside the shiny session
registerCandleStick <- function(){
  # Try to remove the input Handler as shiny does not allow double input
  # handlers
  try({ removeInputHandler("CandleStickBinding") })
  
  # Use the shiny registerInputHandler function to
  # register a way to deal with the inputs coming
  shiny::registerInputHandler(
    "CandleStickBinding", 
    function(x, shinysession, name) {
      return(x)
    }
  )
}

#' Update a candlestick value
#' 
#' @export
#' 
#' @param inputId ID of Canldestick
#' @param value on / off / default
#' 
updateCandleStick <- function(inputId, value="on"){
  stopifnot(!value %in% c("on","off","default"))
  shinyjs::runjs(paste0("$('#",inputId,"').candlestick('",value,"');"))
}
