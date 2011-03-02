xml.instruct! :xml, :version =>"1.0"
xml.rss :version => "2.0" do
    xml.channel do
    xml.title "Posts du Twitter-like qui tue"
    xml.description "Ensemble des posts du Twitter-like qui tue"
    xml.link microposts_url(:rss)

    for post in @microposts
      xml.item do
        xml.title post.content
        xml.description post.content
        xml.author post.user.name
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link user_url(post.user, :rss)
     end
    end
  end
end