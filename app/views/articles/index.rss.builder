xml.instruct! :xml
xml.rss :version => "2.0" do
	xml.channel do
		xml.title "Northern Laramie Range Alliance"
		xml.description "News headlines for the NLRA"
		xml.link articles_url
		
		for article in @articles
			xml.item do
				xml.title article.title
				xml.description article.body
				xml.pubDate article.created_at.to_s(:rfc822)
				xml.link article_url(article)
				xml.guid article_url(article)
			end
		end
	end
end