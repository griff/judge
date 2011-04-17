(function($) { // Hide scope, no $ conflict

$.svgweb = {
    rect: function(rect) {
        return {x:rect.x, y:rect.y, width:rect.width, height:rect.height};
    },
    matrix: function(matrix) {
        this.a = matrix.a; this.c = matrix.c; this.e = matrix.e;
        this.b = matrix.b; this.d = matrix.d; this.f = matrix.f;
    },
};
$.svgweb.matrix.prototype = {
    transform:function() {
        return "matrix(" + this.a + "," + this.b + "," + this.c + "," + this.d + "," + this.e + "," + this.f + ")";
    }
}

$.fn.extend({
    viewBox: function(options) {
    	var elem = this[0];

    	if ( options ) {
    		return this.each(function( i ) {
    		    var self = this,
    		        viewBox = self.viewBox;
    		    if($.isSVG(self) && viewBox) {
        		    var value = options,
        		        baseVal = viewBox.baseVal,
        		        cloned = $.svgweb.rect(baseVal);
        		    if($.isFunction(value)) {
        		        value = value.call(self, i, cloned);
        		    }
        			if(typeof value.x !== "undefined") {
        			    baseVal.x = value.x;
        			}
        			if(typeof value.y !== "undefined") {
        			    baseVal.y = value.y;
        			}
        			if(typeof value.width !== "undefined") {
        			    baseVal.width = value.width;
        			}
        			if(typeof value.height !== "undefined") {
        			    baseVal.height = value.height;
        			}
    		    }
    		});
    	}

    	if ( !elem || !elem.ownerDocument || !$.isSVG(elem) || !elem.viewBox ) {
    		return null;
    	}
        return $.svgweb.rect(elem.viewBox.baseVal);
    },
    svgCTM: function(ctm) {
    	var elem = this[0];

    	if ( ctm ) {
		    return this.each(function( i ) {
        	    var self = this;
    		    if($.isSVG(self) && self.transform) {
        		    var value = ctm,
        		        matrix = self.transform.baseVal.consolidate().matrix,
        		        cloned = new $.svgweb.matrix(matrix);
        		    if($.isFunction(value)) {
        		        value = value.call(self, i, $(this).svgMatrix(matrix));
        		    }
        		    if(typeof value.a !== "undefined") {
        		        cloned.a = value.a;
        		    }
        		    if(typeof value.b !== "undefined") {
        		        cloned.b = value.b;
        		    }
        		    if(typeof value.c !== "undefined") {
        		        cloned.c = value.c;
        		    }
        		    if(typeof value.d !== "undefined") {
        		        cloned.d = value.d;
        		    }
        		    if(typeof value.e !== "undefined") {
        		        cloned.e = value.e;
        		    }
        		    if(typeof value.f !== "undefined") {
        		        cloned.f = value.f;
        		    }
        		    self.setAttribute("transform", cloned.transform());
    		    }
    		});
    	}

    	if ( !elem || !$.isSVG(elem) || !elem.ownerSVGElement || !elem.transform ) {
    		return null;
    	}
    	var ret = elem.ownerSVGElement.createSVGMatrix(),
    	    current = elem.transform.baseVal.consolidate().matrix;
    	ret.a = current.a; ret.c = current.c; ret.e = current.e;
    	ret.b = current.b; ret.d = current.d; ret.f = current.f;
        return ret;
    },
    
    svgPoint: function(x,y) {
        var elem = this[0];
    	if ( !elem || !$.isSVG(elem) || !elem.ownerDocument ) {
    		return null;
    	}
    	var ret = elem.ownerDocument.rootElement.createSVGPoint();
    	if($.isFunction(x)) {
    	    x = x.call(elem, ret, y);
    	}
    	if(typeof x !== "undefined") {
    	    if(typeof x.x !== "undefined") {
    	        ret.x = x.x;
    	    }
    	    if(typeof x.y !== "undefined") {
    	        ret.y = x.y;
    	    }
    	    if(typeof x.x !== "undefined" || typeof x.y !== "undefined")
    	        return ret;
    	    ret.x = x;
    	}
    	if(typeof y !== "undefined") {
    	    ret.y = y;
    	}
    	return ret;
    },
    
    svgMatrix: function(a, b, c, d, e, f) {
        var elem = this[0];
    	if ( !elem || !$.isSVG(elem) || !elem.ownerDocument ) {
    		return null;
    	}
    	var ret = elem.ownerDocument.rootElement.createSVGMatrix();
    	if($.isFunction(a)) {
    	    a = a.call(elem, ret, b, c, d, e, f);
    	}
    	if(typeof a !== "undefined") {
    	    var returnNow = false;
    	    if(typeof a.a !== "undefined") {
    	        ret.a = a.a;
    	        returnNow = true;
    	    }
    	    if(typeof a.b !== "undefined") {
    	        ret.b = a.b;
    	        returnNow = true;
    	    }
    	    if(typeof a.c !== "undefined") {
    	        ret.c = a.c;
    	        returnNow = true;
    	    }
    	    if(typeof a.d !== "undefined") {
    	        ret.d = a.d;
    	        returnNow = true;
    	    }
    	    if(typeof a.e !== "undefined") {
    	        ret.e = a.e;
    	        returnNow = true;
    	    }
    	    if(typeof a.f !== "undefined") {
    	        ret.f = a.f;
    	        returnNow = true;
    	    }
    	    if(returnNow)
    	        return ret;
    	    ret.a = a;
    	}
	    if(typeof a !== "undefined") {
	        ret.a = a;
	    }
	    if(typeof b !== "undefined") {
	        ret.b = b;
	    }
	    if(typeof c !== "undefined") {
	        ret.c = c;
	    }
	    if(typeof d !== "undefined") {
	        ret.d = d;
	    }
	    if(typeof e !== "undefined") {
	        ret.e = e;
	    }
	    if(typeof f !== "undefined") {
	        ret.f = f;
	    }
    	return ret;
    }
});

})(jQuery);