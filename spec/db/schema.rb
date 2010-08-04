ActiveRecord::Schema.define(:version => 20100803160738) do

  create_table "posts", :force => true do |t|
    t.string   "title",      :null => false
    t.text     "body",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["created_at"], :name => "index_posts_on_created_at"

end
