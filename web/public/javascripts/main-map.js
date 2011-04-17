var svgdoc = null,
    svgViewBox = null,
    svgRoot;
jQuery(function($) {
    window.addEventListener("SVGLoad", function() {
        svgdoc = $('#map')[0].contentDocument;
        var root = svgRoot = $(svgdoc.rootElement),
            hash = window.location.hash;
        svgViewBox = root.viewBox();
        if(hash.length > 1) {
            $('#viewport', svgdoc).attr('transform', hash.substring(1));
            
            //console.log("Location " + hash + " " + $('#viewport', svgdoc).attr('transform'));
        }
        
        svgRoot.mousedown(function(event) {
            var p = svgRoot.svgPoint(event.clientX, event.clientY),
                viewport = $('#viewport', this),
                theCTM = viewport[0].getCTM().inverse(),
                ctm = viewport.svgCTM();

            p = p.matrixTransform(theCTM);
            console.log('Down', event, p.x, p.y);
            svgRoot.bind('mousemove.panning', function(event) {
                var np = svgRoot.svgPoint(event.clientX, event.clientY).matrixTransform(theCTM);
                viewport.svgCTM(ctm.translate(np.x-p.x, np.y-p.y));
            }).bind('mouseup.panning', function(event) {
                svgRoot.unbind('.panning');

                var np = svgRoot.svgPoint(event.clientX, event.clientY),
                    aCTM = viewport[0].getCTM(),
                    p0 = svgRoot.svgPoint().matrixTransform(aCTM),
                    pe = svgRoot.svgPoint(svgViewBox.width, svgViewBox.height).matrixTransform(aCTM),
                    width = root.width(),
                    height = root.height(),
                    ppWidth = pe.x-p0.x,
                    ppHeight = pe.y-p0.y;

                console.log('Up', p0.x, p0.y, pe.x, pe.y, width, height);
                
                if(p0.y > 0) {
                    if(ppHeight >= height) {
                        np.y = np.y - p0.y;
                    } else {
                        np.y = np.y - p0.y + height/2 - ppHeight/2;
                    }
                }else if(pe.y < height) {
                    if(ppHeight >= height) {
                        np.y = np.y - pe.y + height;
                    } else {
                        np.y = np.y - p0.y + height/2 - ppHeight/2;
                    }
                }
                if(p0.x > 0) {
                    if(ppWidth >= width) {
                        np.x = np.x - p0.x;
                    } else {
                        np.x = np.x - p0.x + width/2 - ppWidth/2;
                    }
                } else if(pe.x < width) {
                    if(ppWidth >= width) {
                        np.x = np.x - pe.x + width;
                    } else {
                        np.x = np.x - (p0.x-(width/2 - ppWidth/2));
                    }
                }
                np = np.matrixTransform(theCTM);
                viewport.svgCTM(ctm.translate(np.x-p.x, np.y-p.y));
            });
        });
        svgRoot.addClass('panable');
        $('#ber-mouse', svgdoc).mousedown(function(event) {
            event.stopPropagation();
        });
    });
    $(window).resize(function(event) {
        var height = $(window).height()-20,
            map = $('#map');
            map.css('height', height);
    });
    $(window).resize();

    var createdLocation = null;
    $('a.map-location').mouseenter(function(event) {
        if(svgdoc) {
            var self = $(this),
                href = self.attr('href'),
                id = href.substring(1),
                existing = $(href + '-mouse', svgdoc),
                layer;

            if(createdLocation) {
                createdLocation.remove();
                createdLocation = null;
            }
            if(existing.length == 0) {
                createdLocation = $(svgdoc.createElementNS(svgns, 'use'));
                layer = $('g#mouse-tracking', svgdoc);
                createdLocation.attr({'xlink:href':href, id:id+'-mouse'}).addClass('hover').appendTo(layer);
            }
            else {
                existing.addClass('hover');
            }
            console.log('Enter', existing.length, existing.selector);
        }
    }).mouseleave(function(event) {
        if(svgdoc) {
            console.log('Leave', $(this).attr('href'), createdLocation, svgdoc);
            if(createdLocation) {
                createdLocation.remove();
                createdLocation = null;
            } else {
                $($(this).attr('href') + '-mouse', svgdoc).removeClass('hover');
            }
        }
    });


    $('#zoomIn').click(function(event) {
        var viewport = $('#viewport', svgdoc),
            ctm = viewport.svgCTM(),
            theCTM = viewport[0].getCTM(),
            point = viewport.svgPoint().matrixTransform(theCTM),
            point2 = viewport.svgPoint().matrixTransform(theCTM.inverse()),
            k = svgRoot[0].createSVGMatrix().translate(579,482.5).scale(1.2).translate(-579,-482.5);

        console.log('Point', point.x, point.y, point2.x, point2.y);
        viewport.svgCTM(ctm.multiply(k));
        $('#link').val(viewport.attr('transform').replace(/\s/g, ""));
    });
    $('#zoomOut').click(function(event) {
        var viewport = $('#viewport', svgdoc),
            ctm = viewport.svgCTM(),
            k = svgRoot[0].createSVGMatrix().translate(579,482.5).scale(1.0/1.2).translate(-579,-482.5);

        viewport.svgCTM(ctm.multiply(k));
        $('#link').val(viewport.attr('transform').replace(/\s/g, ""));
    });
    $('#zoomFit').click(function(event) {
        var viewport = $('#viewport', svgdoc);
        viewport.attr('transform', 'translate(0,0)');
        $('#link').val("");
    });
});