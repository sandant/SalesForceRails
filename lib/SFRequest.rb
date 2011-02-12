module SFRequest
  require 'Token'
  require 'cgi'

  INSTANCE_URL = 'https://na8.salesforce.com'

  def SFRequest.get_news_feed
    response = JSON.parse(Token::get_token.get("#{INSTANCE_URL}/services/data/v21.0/query/?q=#{CGI::escape('SELECT FeedPost.Body, CreatedDate, CreatedBy.Name, FeedPost.CreatedBy.SmallPhotoUrl FROM NewsFeed WHERE (Type <> \'Content\' AND Type <> \'TrackedChange\') LIMIT 4')}"))
    return response
  end

  def SFRequest.search keyword
    response = Token::get_token.get("#{INSTANCE_URL}/services/data/v21.0/search?q=#{CGI::escape('FIND+\'#{keyword}*\'+IN+ALL+FIELDS+RETURNING+Account')}")
    return response
  end
end
