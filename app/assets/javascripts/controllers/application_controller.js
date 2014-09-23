Houston.ApplicationController = Ember.ObjectController.extend(EmberPusher.Bindings, {
	needs: "issuesIndex",
	PUSHER_SUBSCRIPTIONS: {
		'kevin-powell-pusher-channel': ['github_issue_sync_count', 'github_issue_synced']
	},
	issues_to_by_synced: 0,
	issues_synchronized: false,
	progress_bar_width: "width:0;",
	github_sync_complete: false,
	syncing: false,
	actions: {
		githubIssueSyncCount: function(data) {
			this.issues_to_be_synced = data.total_issues;
			this.issues_synchronized = 0;

			if (this.issues_synchronized == this.issues_to_be_synced) {
				alert("NOTHING TO SYNC");
			}
		},
		githubIssueSynced: function(data) {
			this.issues_synchronized = this.issues_synchronized + 1;

			if (this.issues_synchronized == this.issues_to_be_synced) {
				this.get("controllers.issuesIndex").send("githubSyncComplete");
				this.set('progress_bar_width', 'width:100%;');
				this.set('github_sync_complete', true);
				this.set('syncing', false);
			}
			else {
				var width = ( this.issues_synchronized / this.issues_to_be_synced ) * 100;
				this.set('progress_bar_width', 'width:' + width + '%;');
				this.set('syncing', true);
			}
		},
	    syncGithubIssues: function() {
			this.set('progress_bar_width', 'width:0;');
			this.set('syncing', true);
			this.set('github_sync_complete', false);

			$.ajax({
				url:'/synchronize-github-issues-for-user/' + current_user_id,
				type: 'PUT'
			});
	    	// alert("SYNC GITHUB ISSUES");
	    }
	}
});