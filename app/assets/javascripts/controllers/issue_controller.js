Houston.IssueController = Ember.ObjectController.extend({
  archived: function(key, value){
    var model = this.get('model');
    console.log(model);

    if (value === undefined) {
      // property being used as a getter
      return model.get('archived');
    } else {
      // property being used as a setter
      model.set('archived', value);
      model.save();
      return value;
    }
  }.property('model.archived')
});