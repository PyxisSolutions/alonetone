# -*- encoding : utf-8 -*-
require 'active_record/fixtures'

admin = User.create(:login => 'admin', :password => 'testing123', :password_confirmation => 'testing123')
admin.update_attribute(:admin, true)

admin = User.find_by_login("admin")

forum = Forum.create
forum.name = "Making Music"
forum.description = "Talk about how you do it, how you want to do it, and how you feel about it."
forum.save

topic = admin.topics.create(
  :title => "Music and passion",
  :body => "alonetone rocks!"
)

topic.forum = forum
topic.save

post = admin.posts.create(
  :body => "keep moving on"
)

post.topic = topic
post.forum = forum
post.save