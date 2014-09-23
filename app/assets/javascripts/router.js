Houston.Router.reopen({
	location: 'auto'
});

Houston.Router.map(function() {
	this.resource('issues', { path: '/'}, function () {
		this.route('by-client', {path: ':slug/client/:client_name'});
	});

});

Houston.ApplicationRoute = Ember.Route.extend(EmberPusher.Bindings, {
	PUSHER_SUBSCRIPTIONS: {
		'kevin-powell-pusher-channel': ['github_issue_sync_count', 'github_issue_synced']
	}
});

Houston.IssuesIndexRoute = Houston.ApplicationRoute.extend({
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
			console.log("refreshing");
		  this.refresh();
		}
	},
	model: function() {
		this.store.find('issue');
		return this.store.filter('issue', function(issue) {
			if (!issue.get('archived') && issue.get('assignee') == 'kevinmpowell')
			return issue;
		});
	}
});

Houston.IssuesByClientRoute = Houston.ApplicationRoute.extend({
	controllerName: 'issues_index',
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
			console.log("refreshing");
		  this.refresh();
		}
	},
	model: function(params){
		this.store.find('issue');
		return this.store.filter('issue', function(issue) {
			if (issue.get('client_name') == params.client_name && !issue.get('archived') && issue.get('assignee') == 'kevinmpowell')
			return issue;
		});
	},
	renderTemplate: function(controller) {
		this.render('issues/index', {controller: 'issues_index'});
	}
})