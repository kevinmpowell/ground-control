Houston.IssuesIndexController = Ember.ArrayController.extend({
  actions: {
  },
  visible: function() {
    return this.get('length');
  }.property('length'),
  inflection: function() {
    var visible = this.get('visible');
    return visible === 1 ? 'issue' : 'issues';
  }.property('visible')
});