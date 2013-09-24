require 'spec_helper'

describe "OrderByPrimaryKeyEngine" do

  context "User" do

    context 'has a default scope by primary key' do

      it { User.limit(1).to_sql.should == "SELECT  \"users\".* FROM \"users\"  ORDER BY users.id LIMIT 1" }

      context 'and another order' do
        it { User.order(:email).limit(1).to_sql.should == "SELECT  \"users\".* FROM \"users\"  ORDER BY email, users.id LIMIT 1" }
      end

      context 'and 2 orders' do
        it { User.order(:email).order(:name).limit(1).to_sql.should == "SELECT  \"users\".* FROM \"users\"  ORDER BY name, email, users.id LIMIT 1" }
      end

      context 'in joins' do
        it { User.joins(:posts).limit(1).to_sql.should == "SELECT  \"users\".* FROM \"users\" INNER JOIN \"posts\" ON \"posts\".\"user_id\" = \"users\".\"id\" ORDER BY users.id, title, posts.id LIMIT 1" }

        it { Forum.joins(:posts).limit(1).to_sql.should == "SELECT  \"forums\".* FROM \"forums\" INNER JOIN \"topics\" ON \"forums\".\"id\" = \"topics\".\"forum_id\" INNER JOIN \"posts\" ON \"posts\".\"topic_id\" = \"topics\".\"id\" ORDER BY forums.description, forums.id, title, posts.id LIMIT 1" }

        it { Forum.joins(:enabled_posts).limit(1).to_sql.should == "SELECT  \"forums\".* FROM \"forums\" INNER JOIN \"topics\" ON \"forums\".\"id\" = \"topics\".\"forum_id\" INNER JOIN \"posts\" ON \"posts\".\"topic_id\" IS NULL AND \"posts\".\"enabled\" = 't' ORDER BY forums.description, forums.id, title, posts.id LIMIT 1" }

        context 'in eager loading joins' do
          let!(:forum1) { Forum.create!(description: '2 - Last in result') }
          let!(:forum1_topic1) { Topic.create!(forum_id: forum1.id, title: '2 - Second in result') }
          let!(:forum1_topic2) { Topic.create!(forum_id: forum1.id, title: '1 - First in result') }
          let!(:forum1_topic3) { Topic.create!(forum_id: forum1.id, title: '3 - Third in result') }
          let!(:forum2) { Forum.create!(description: '1 - First in result') }

          let!(:result) { Forum.find(:all, :include => :topics) }

          it { result.count.should == 2 }
          it { result.first.should eq forum2 }
          it { result.last.should eq forum1 }

          it { result.last.topics.count.should == 3 }
          it { result.last.topics.first.should eq forum1_topic2 }
          it { result.last.topics.second.should eq forum1_topic1 }
          it { result.last.topics.last.should eq forum1_topic3 }
        end
      end

      context 'and another scope by order which be the first' do
        it { User.name_sort.to_sql.should == "SELECT \"users\".* FROM \"users\"  ORDER BY name, users.id" }
      end

      context 'and has reorder' do
        it { User.reorder(:name).to_sql.should == "SELECT \"users\".* FROM \"users\"  ORDER BY name" }
        it { User.reorder(:name).order(:id).to_sql.should == "SELECT \"users\".* FROM \"users\" ORDER BY id, name" }
      end

    end

  end

  context 'Post' do

    context 'has 2 default scopes' do
      it { Post.limit(1).to_sql.should == "SELECT  \"posts\".* FROM \"posts\" ORDER BY title, posts.id LIMIT 1" }
    end

  end

end