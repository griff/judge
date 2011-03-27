module Judge
  class JudgeError < StandardError
  end

  class InvalidMapError < JudgeError
  end

  class AlreadySupplyCenterError < JudgeError
  end

  class MissingPowerError < JudgeError
  end

  class MissingLocationsError < JudgeError
  end

  class InvalidLocationError < JudgeError
  end
  
  class InvalidPowerError < JudgeError
  end

  # When trying to own a supply center that is already owner by another power
  class AlreadyOwnedCenterError < JudgeError
  end
  
  # When trying to assign as a home supply center that is already the home of another power
  class AlreadyHomeCenterError < JudgeError
  end
end