Houston.IssuesIndexController = Ember.ArrayController.extend(EmberPusher.Bindings, {
	PUSHER_SUBSCRIPTIONS: {
		'kevin-powell-pusher-channel': ['github_issue_sync_count', 'github_issue_synced']
	},
  actions: {
  	githubIssueSyncCount: function(data) {
  		var issues_to_be_synced = data.total_issues;
		var issues_synchronized = 0; //reset count if syncing again
		console.log("TO BE SYNCED: " + issues_to_be_synced);

		if (data.total_issues == 0) {
			alert("GITHUB SYNC COMPLETE");
		}
  	},
  	githubIssueSynced: function(data) {
  		this.get('model').forEach(function(record){
		  record.reload();
		});
  	}
  },
  visible: function() {
    return this.get('length');
  }.property('length'),
  inflection: function() {
    var visible = this.get('visible');
    return visible === 1 ? 'issue' : 'issues';
  }.property('visible')
});