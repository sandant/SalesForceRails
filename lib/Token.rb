module Token
  def Token.set_token token
    @token = token
    @token_created_date = Time.now
  end

  def Token.get_token
    unless @token_created_date.nil?
      if @token_created_date < (Time.now - (60 * 60 * 4))
        reset_token
      else
        return @token
      end
    end
  end

  def reset_token
    set_token nil
  end
end
