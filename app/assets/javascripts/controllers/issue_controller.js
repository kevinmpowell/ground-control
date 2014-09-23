Houston.IssueController = Ember.ObjectController.extend({
  actions: {
    archiveIssue: function() {
      var issue = this.get('model');
      issue.set('archived', true);
      issue.save();
    }
  }
});