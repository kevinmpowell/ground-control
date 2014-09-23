Houston.IssuesIndexController = Ember.ArrayController.extend({
  sortProperties: ['local_sort_order'],
  sortAscending: true,
  visible: function() {
    return this.get('length');
  }.property('length'),
  inflection: function() {
    var visible = this.get('visible');
    return visible === 1 ? 'issue' : 'issues';
  }.property('visible'),
  actions: {
    archiveIssue: function() {
      var issue = this.get('model');
      issue.set('archived', true);
      issue.save();
    }
  }
});