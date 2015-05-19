class Employee
  attr_reader :name, :email, :phone, :salary, :satisfactory

  def initialize(name:, email:, phone:, salary:)
    @name = name
    @email = email
    @phone = phone
    @salary = salary
    @satisfactory = nil
  end

  # use to add a review to a employee
  def add_review(review)
    @review = review
  end

  # sets boolean determining if employee is satisfactory or not
  def satisfactory?(bool)
      @satisfactory = bool
  end

  def give_raise(amount)
    @salary += amount
  end

  def evaluate_review

    pos_words = ["absolutely", "accepted", "acclaimed", "accomplish", "achievement", "action",
      "active", "admire", "affirmative", "agree", "amazing", "angelic",
      "appeal", "approve", "aptitude", "attractive", "awesome", "beaming", "beautiful",
      "believe", "beneficial", "bliss", "bountiful", "brave", "bravo", "brilliant",
      "bubbly", "calm", "celebrated", "certain", "champ", "charming", "cheery", "choice",
      "classic", "classical", "clean", "commend", "composed", "congratulation", "complete",
      "constant", "cool", "courageous", "creative", "cute", "dazzling", "delight",
      "delightful", "distinguished", "divine", "earnest", "easy", "ecstatic", "effective",
      "effervescent", "efficient", "effortless", "electrifying", "elegant", "enchanting",
      "encouraging", "endorsed", "energetic", "energized", "engaging", "encourage",
      "enthusiastic", "essential", "esteemed", "ethical", "excellent", "exciting",
      "exquisite", "fabulous", "fair", "familiar", "famous", "fantastic", "favorable",
      "fetching", "fine", "fitting", "flourishing", "fortunate", "free", "fresh",
      "friendly", "fun", "funny", "generous", "genius", "genuine", "giving", "glamorous",
      "glowing", "good", "gorgeous", "graceful", "great", "green", "grin", "growing",
      "handsome", "happy", "harmonious", "healing", "healthy", "hearty", "heavenly",
      "honest", "honorable", "honored", "idea", "imaginative", "incredible",
      "imagine", "impressive", "independent", "innovate", "innovative", "instant",
      "instinctive", "intuitive", "intellectual", "intelligent", "inventive",
      "jovial", "joy", "jubilant", "keen", "kind", "knowing", "knowledgeable",
      "laugh", "legendary", "light", "learned", "lively", "lovely", "lucid",
      "lucky", "luminous", "marvelous", "masterful", "meaningful", "merit",
      "meritorious", "miraculous", "motivating", "moving", "natural", "nice",
      "novel", "now", "nurturing", "nutritious", "okay", "one-hundred percent",
      "open", "optimistic", "paradise", "perfect", "phenomenal", "pleasurable",
      "plentiful", "pleasant", "poised", "polished", "popular", "positive",
      "powerful", "prepared", "pretty", "principled", "productive", "progress",
      "prominent", "protected", "proud", "quality", "quick", "quiet", "ready",
      "reassuring", "refined", "refreshing", "rejoice", "reliable", "remarkable",
      "resounding", "respected", "restored", "reward", "rewarding", "right",
      "robust", "safe", "satisfactory", "secure", "seemly", "simple", "skilled",
      "skillful", "smile", "soulful", "sparkling", "special", "spirited",
      "spiritual", "stirring", "stupendous", "stunning", "success", "successful",
      "sunny", "super", "superb", "supporting", "surprising", "terrific", "thorough",
      "thrilling", "thriving", "tops", "tranquil", "transforming", "transformative",
      "trusting", "truthful", "unreal", "unwavering", "upbeat", "upright", "upstanding",
      "valu", "vibrant", "victorious", "victory", "vigorous", "virtuous", "vital",
      "vivacious", "wealthy", "welcome", "well", "whole", "wholesome", "willing",
      "wonderful", "wondrous", "worthy", "wow", "yes", "yummy", "zeal", "zealous",
      "fair", "favor", "pleaseant"]

    neg_words = ["abysmal", "adverse", "alarming", "angry", "annoy", "anxious", "apathy",
      "appalling", "atrocious", "awful", "bad", "banal", "barbed", "belligerent",
      "bemoan", "beneath", "boring", "broken", "callous", "clumsy",
      "coarse", "cold", "collapse", "confused", "contra", "confus", "concern",
      "corrosive", "corrupt", "crazy", "creepy", "criminal", "cruel", "cry",
      "cutting", "dead", "decaying", "damage", "damaging", "deplorable", "difficult",
      "depressed", "deprived", "deformed", "deny", "despicable", "detrimental",
      "dirty", "disease", "disgusting", "disheveled", "dishonorable", "dismal",
      "distress", "dreadful", "dreary", "enraged", "eroding", "evil",
      "fail", "faulty", "fear", "feeble", "fight", "filthy", "foul", "error",
      "fright", "ghastly", "grave", "greed", "grim", "grimace", "unjust",
      "gross", "grotesque", "gruesome", "guilty", "haggard", "hard", "harm",
      "hate", "hideous", "homely", "horrendous", "horrible", "hostile",
      "hurt", "hurtful", "icky", "ignore", "ignorant", "ill", "imperfect",
      "impossible", "inane", "inelegant", "infernal", "injure", "injurious",
      "insane", "insid", "jealous", "junky", "lose", "lousy", "lumpy",
      "malicious", "mean", "menacing", "messy", "misshapen", "missing",
      "misunderstood", "moan", "moldy", "monstrous", "naive", "nasty",
      "naughty", "negate", "never", "nobody", "nondescript", "nonsense",
      "not", "noxious", "objectionable", "odious", "offensive", "old",
      "oppressive", "pain", "perturb", "pessimistic", "petty", "plain",
      "poisonous", "poor", "prejudice", "questionable", "quirky", "quit",
      "reject", "renege", "repellant", "reptilian", "repulsive", "repugnant",
      "revenge", "revolting", "rocky", "rotten", "rude", "ruthless", "sad",
      "savage", "scare", "scary", "scream", "severe", "shoddy", "shocking",
      "sick", "sickening", "sinister", "sobbing", "sorry", "spiteful",
      "stressful", "stuck", "stupid", "substandard", "suspect", "suspicious",
      "tense", "terrible", "terrifying", "threatening", "ugly", "undermine",
      "upset",  "vice", "vicious", "vile", "villainous", "vindictive", "wary",
      "weary", "wicked", "woeful", "worthless", "wound", "yell", "zero"]

      sentences = []
      sentences = @review.split('.')
      pos = 0
      neg = 0

      pos_words.each { |w| sentences.each {|s| neg += s.scan(/not\s\w*\s#{w}/i).length}}
      pos_words.each { |w| sentences.each {|s| neg += s.scan(/(not)\s#{w}/i).length}}
      pos_words.each { |w| sentences.each {|s| neg += s.scan(/(dis|un)#{w}/i).length}}
      neg_words.each { |w| sentences.each {|s| neg += s.scan(/\s#{w}/i).length}}

      neg_words.each { |w| sentences.each {|s| pos += s.scan(/not\s\w*\s#{w}/i).length}}
      neg_words.each { |w| sentences.each {|s| pos += s.scan(/(not)\s#{w}/i).length}}
      pos_words.each { |w| sentences.each {|s| pos += s.scan(/\s#{w}/i).length}}
      neg_words.each { |w| sentences.each {|s| pos += s.scan(/(dis|un)#{w}/i).length}}

      if neg >= pos
        @satisfactory = false
      else
        @satisfactory = true
      end
    
  end


end
