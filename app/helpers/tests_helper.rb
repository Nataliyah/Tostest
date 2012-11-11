module TestsHelper
  
  def helper_iconSize
    return "16x16"
  end
  
  def helper_flag
    flag = case session[:lang]
    when 'ang_pol' then 'ang_pol.png'
    when 'pol_ang' then 'pol_ang.png'
    end
    return flag
  end
  
  def helper_langLabel
    lang = case session[:lang]
    when 'ang_pol' then "Polski"
    when 'pol_ang' then "English"
    end
    return lang
  end
  
  def helper_sourceWord(word)
    word = case session[:lang]
    when 'ang_pol' then word.ang
    when 'pol_ang' then word.pol1
    end
    return word
  end
  
end
