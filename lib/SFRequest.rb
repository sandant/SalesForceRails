module SFRequest
  require 'Token'
  require 'cgi'

  INSTANCE_URL = 'https://na8.salesforce.com/services/data/v21.0/'

  def SFRequest.get_news_feed
    response = JSON.parse(Token::get_token.get("#{INSTANCE_URL}query/?q=#{CGI::escape('SELECT FeedPost.Body, CreatedDate, CreatedBy.Name, FeedPost.CreatedBy.SmallPhotoUrl FROM NewsFeed WHERE (Type <> \'Content\' AND Type <> \'TrackedChange\') LIMIT 4')}"))
    return response
  end

  def SFRequest.search keyword
    response = JSON.parse(Token::get_token.get("#{INSTANCE_URL}search?q=FIND+{*#{keyword}*}+IN+ALL+FIELDS+RETURNING+Account(Id,Name),Contact(Id,Name),Lead(Id,Name),FeedPost(Id,Body)"))
    return response
  end

  def SFRequest.get_sobject id, type
    uri = "#{INSTANCE_URL}/services/data/v21.0/query/?q="
    case type
      when 'Account'
        uri += "SELECT Id, Name, Website, Description, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity FROM Account WHERE Id = '#{id}' LIMIT 1"
      when 'Contact'
        uri += "SELECT Id, Name FROM Contact WHERE Id = '#{id}' LIMIT 1"
      when 'Lead'
        uri += "SELECT Id, Name FROM Lead WHERE Id = '#{id}' LIMIT 1"
    end

    response = JSON.parse(Token::get_token.get(uri))
    return response
  end

  def SFRequest.update_account id
    response = JSON.parse(Token::get_token.post("#{INSTANCE_URL}sobjects/Account/#{id}?_HttpMethod=PATCH", "{\"Name\":\"#{new_name}\",\"BillingCity\":\"#{city}\"}", {'Content-type' => 'application/json'})
  end

end
