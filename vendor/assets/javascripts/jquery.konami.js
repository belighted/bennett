/*!
 * This is a textual konami jquery plugin. It allows people to
 * embed easter eggs in their websites ala konami style. 
 *
 * If you would like to have more information about the 
 * konami-code sequences, you might be interested in looking at
 * {http://en.wikipedia.org/wiki/Konami_Code}
 *
 * Beware that the textual map only contains the following:
 *  left, right, up, down, a, b
 *
 * If you want to invoke or use konami, simply do that:
 *
 * <code>
 *    $(document).konami({
 *        code: ['left', 'left'],
 *        callback: function() {
 *            alert('easter egg!!!');
 *        }
 *    });
 * </code>
 *
 * Author: David Coallier <david.coallier@gmail.com>
 * License: New BSD
 * Link: http://github.com/davidcoallier/jquery-konami
 * Date: 1st October, 2010
 */
(function(jQuery) {
    jQuery.fn.konami = function(opts) {
        var enteredKeys = [];

        var textualKeyMap = {
            'left' : 37,
            'up'   : 38,
            'right': 39,
            'down' : 40,
            'a'    : 65,
            'b'    : 66
        };
        
        var options = jQuery.extend({
            code : ['up', 'up', 'down', 'down', 'left', 'right', 'left', 'right', 'b', 'a'],
            callback : function() {}
        }, opts);

        var codes = options.code;

        var solutionCodes = [];
        $.each(codes, function(i, item) {
            if (codes[i] !== undefined && textualKeyMap[codes[i]] !== undefined) {
                solutionCodes.push(textualKeyMap[codes[i]]);
            } else if (codes[i] !== undefined && typeof(codes[i]) == 'number') {
                // This is in case one wants to pass direct keycodes instead of textual keycodes.
                solutionCodes.push(codes[i]);
            }
        });

        $(document).keyup(function(e) {
            var keyCode = e.keyCode ? e.keyCode : e.charCode;
            enteredKeys.push(keyCode);

            if (enteredKeys.toString().indexOf(solutionCodes) >= 0) {
                enteredKeys = [];
                options.callback($(this));
            }
        });
    }
})(jQuery);
