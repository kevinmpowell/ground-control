Houston.ApplicationController = Ember.ObjectController.extend({
  actions: {
    syncGithubIssues: function() {
		$.ajax({
			url:'/synchronize-github-issues-for-user/' + current_user_id,
			type: 'PUT'
		});
    	// alert("SYNC GITHUB ISSUES");
    }
  }
});