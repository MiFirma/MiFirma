require "test_helper"

class ActiveRecordTest < ActiveSupport::TestCase

  context "relationship_with" do

    should "return relationship between Post and Comment" do
      assert_equal :has_many, Post.relationship_with(Comment)
    end

    should "return relationship between Comment and Post" do
      assert_equal :belongs_to, Comment.relationship_with(Post)
    end

    should "return relationship between Post and Category" do
      assert_equal :has_and_belongs_to_many, Post.relationship_with(Category)
    end

    should "return relationship between Category and Post" do
      assert_equal :has_and_belongs_to_many, Category.relationship_with(Post)
    end

    should "return relationship between Order and Invoice" do
      assert_equal :has_one, Order.relationship_with(Invoice)
    end

    should "return relationship between Invoice and Order" do
      assert_equal :belongs_to, Invoice.relationship_with(Order)
    end

    should "return relationship between Invoice and TypusUser" do
      assert_equal :belongs_to, Invoice.relationship_with(TypusUser)
    end

    should "return relationship between TypusUser and Invoice" do
      assert_equal :has_many, TypusUser.relationship_with(Invoice)
    end

  end

  context "mapping" do

    teardown do
      Post.send(:remove_const, :STATUS)
      Post::STATUS = { "Draft" => "draft",
                       "Published" => "published",
                       "Unpublished" => "unpublished",
                       "<div class=''>Something special</div>".html_safe => "special" }
    end

    context "with an array" do

      setup do
        Post.send(:remove_const, :STATUS)
        Post::STATUS = %w(pending published unpublished)
      end

      should "work for symbols" do
        post = Factory(:post)
        assert_equal "published", post.mapping(:status)
      end

      should "work for strings" do
        post = Factory(:post, :status => "unpublished")
        assert_equal "unpublished", post.mapping('status')
      end

      should "for unexisting keys returning the current key" do
        post = Factory(:post, :status => "unexisting")
        assert_equal "unexisting", post.mapping(:status)
      end

    end

    context "with a two dimension array" do

      setup do
        Post.send(:remove_const, :STATUS)
        Post::STATUS = [["Publicado", "published"],
                        ["Pendiente", "pending"],
                        ["No publicado", "unpublished"]]
      end

      should "verify" do
        post = Factory(:post)
        assert_equal "Publicado", post.mapping(:status)
        post = Factory(:post, :status => "unpublished")
        assert_equal "No publicado", post.mapping(:status)
      end

    end

    context "with a hash" do

      setup do
        Post.send(:remove_const, :STATUS)
        Post::STATUS = { "Pending - Hash" => "pending",
                         "Published - Hash" => "published",
                         "Not Published - Hash" => "unpublished" }
      end

      should "verify" do
        page = Factory(:post)
        assert_equal "Published - Hash", page.mapping(:status)
        page = Factory(:post, :status => "unpublished")
        assert_equal "Not Published - Hash", page.mapping(:status)
      end

    end

  end

  context "to_label" do

    should "return email for TypusUser" do
      typus_user = Factory(:typus_user)
      assert_equal typus_user.email, typus_user.to_label
    end

    should "return name for Category" do
      category = Factory(:category, :name => "Chunky Bacon")
      assert_match "Chunky Bacon", category.to_label
    end

    should "return Model#id because Category#name is empty" do
      category = Factory(:category)
      category.name = nil
      category.save(:validate => false)
      assert_equal "Category##{category.id}", category.to_label
    end

    should "return default Model#id" do
      assert_match /Post#/, Factory(:post).to_label
    end

  end

  context "to_resource" do

    should "work for models" do
      assert_equal "typus_users", TypusUser.to_resource
    end

    should "work for namespaced models" do
      assert_equal "delayed/tasks", Delayed::Task.to_resource
    end

  end

end
