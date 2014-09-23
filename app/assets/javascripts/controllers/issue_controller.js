Houston.IssueController = Ember.ObjectController.extend({
	hexToRgb: function(hex) {
	   var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
	    return result ? {
	        r: parseInt(result[1], 16),
	        g: parseInt(result[2], 16),
	        b: parseInt(result[3], 16)
	    } : null;
	},
	badges: function() {
		var badges = JSON.parse(this.get('labels'));
		var processed_badges = [];
		for (var i=0; i<badges.length; i++){
			var badge = badges[i];
			var rgb_color =this.hexToRgb(badge.color);
			var text_color = (rgb_color.r + rgb_color.g + rgb_color.b) < 382.5 ? 'white' : 'black';

			var processed_badge = {
				name: badge.name,
				color: badge.color,
				text_color: text_color,
				css: "color: " + text_color + "; background-color: #" + badge.color + ";"
			};
			processed_badges.push(processed_badge);
		}	
		return processed_badges;
	}.property('labels'),
  	actions: {
    	archiveIssue: function() {
	      var issue = this.get('model');
	      issue.set('archived', true);
	      issue.save();
	    }
  	}
});