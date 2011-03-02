xml.instruct! :xml, :version =>"1.0"
xml.rss :version => "2.0" do
    xml.channel do
    xml.title "Posts de #{@user.name}"
    xml.description "Ensemble des posts de #{@user.name}"
    xml.link user_url(@user, :rss)

    for post in @microposts
      xml.item do
        xml.title post.content
        xml.description post.content
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link user_url(@user)
     end
    end
  end
end