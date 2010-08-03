require 'active_record' unless defined? ActiveRecord

# require 'ruby-debug';
# years = {}
# (Post.minimum("Year(created_at)")..Post.maximum("Year(created_at)")).each do |y|
#   years[y.to_sym] = {}
#   Post.where("Year(created_at)").group("Month(created_at)").map { |p| p.created_at.month }.each do |m|
#     years[y.to_sym][m.to_s.to_sym] = Post.where("Year(created_at) = #{y}").where("Month(created_at) = #{m}").all
#   end
# end
# debugger
# years


module ArchiveTree
  
end # ArchiveTree