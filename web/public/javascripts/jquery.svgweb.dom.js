(function($) { // Hide scope, no $ conflict

var rclass = /[\n\t\r]/g,
    rspaces = /\s+/,
    rBackslash = /\\/g,
    rxlinkprefix = /^xlink:.*/;

$.isSVG = function(node) {
    return (node.nodeType == 1 && node.namespaceURI == svgns);
};

var origAddClass = $.fn.addClass;
$.fn.addClass = function(value) {
    if ( $.isFunction(value) ) {
        return origAddClass.apply(this, arguments);
    }
    
    if ( value && typeof value === "string" ) {
        var classNames = (value || "").split( rspaces );

        for ( var i = 0, l = this.length; i < l; i++ ) {
            var elem = this[i];

            if ( elem.nodeType === 1 ) {
                if ( !elem.className ) {
                    elem.className = value;

                } else {
                    var isSVG = $.isSVG(elem),
                        className = " " + (isSVG ? elem.className.baseVal : elem.className) + " ",
                        setClass = isSVG ? elem.className.baseVal : elem.className,
                        c = 0,
                        cl = classNames.length;

                    for ( var c = 0, cl = classNames.length; c < cl; c++ ) {
                        if ( className.indexOf( " " + classNames[c] + " " ) < 0 ) {
                            setClass += " " + classNames[c];
                        }
                    }
                    if(isSVG) {
                        elem.className.baseVal = $.trim( setClass );
                    } else {
                        elem.className = $.trim( setClass );
                    }
                        
                }
            }
        }
    }

    return this;
};

var origRemoveClass = $.fn.removeClass;
$.fn.removeClass = function( value ) {
    if ( $.isFunction(value) ) {
        return origRemoveClass.apply(this, arguments);
    }

	if ( (value && typeof value === "string") || value === undefined ) {
		var classNames = (value || "").split( rspaces );

		for ( var i = 0, l = this.length; i < l; i++ ) {
			var elem = this[i],
			    isSVG = $.isSVG(elem);

			if ( elem.nodeType === 1 && elem.className ) {
				if ( value ) {
					var className = (" " + (isSVG ? elem.className.baseVal : elem.className) + " ").replace(rclass, " ");
					for ( var c = 0, cl = classNames.length; c < cl; c++ ) {
						className = className.replace(" " + classNames[c] + " ", " ");
					}
					if(isSVG) {
    					elem.className.baseVal = $.trim( className );
					} else {
    					elem.className = $.trim( className );
					}

				} else {
					if(isSVG) {
    					elem.className.baseVal = "";
					} else {
    					elem.className = "";
					}
				}
			}
		}
	}

	return this;
};

$.fn.hasClass = function( selector ) {
	var className = " " + selector + " ";
	for ( var i = 0, l = this.length; i < l; i++ ) {
	    var curr = this[i],
	        currClassName = curr.className;
	    if($.isSVG(curr)) { 
	        currClassName = currClassName.baseVal;
	    }
		if ( (" " + currClassName + " ").replace(rclass, " ").indexOf( className ) > -1 ) {
			return true;
		}
	}

	return false;
};

var origToggleClass = $.fn.toggleClass;
$.fn.toggleClass = function( value, stateVal ) {
	var type = typeof value,
		isBool = typeof stateVal === "boolean";

	if ( $.isFunction( value ) || type === "string") {
        return origToggleClass.apply(this, arguments);
	}

	return this.each(function() {
		if ( type === "undefined" || type === "boolean" ) {
    	    var isSVG = $.isSVG(this)
    	        className = this.className;
    	    if(isSVG) {
    	        className = className.baseVal;
    	    }
			if ( className ) {
				// store className if set
				jQuery._data( this, "__className__", className );
			}

			// toggle whole className
			className = className || value === false ? "" : jQuery._data( this, "__className__" ) || "";
			if(isSVG) {
    			this.className.baseVal = className;
			} else {
    			this.className = className;
			}
		}
	});
}


var origAttr = $.attr;
$.attr = function( elem, name, value, pass ) {
    if ( !elem || elem.nodeType !== 1 || !$.isSVG(elem) || value === undefined || !rxlinkprefix.test(name)) {
        return origAttr.apply(this, arguments);
    }
    // Only handle xlink: attributes
    console.log('Special handle ', name, value);
    elem.setAttributeNS(xlinkns, name, "" + value);
    return origAttr.call(this, elem, name, undefined, pass);
};

// Fix Sizzle class selector
$.expr.filter.CLASS = function( elem, match ) {
	return (" " + (!$.isSVG(elem) && elem.className || elem.getAttribute("class")) + " ")
		.indexOf( match ) > -1;
};

})(jQuery);