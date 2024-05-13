module Constants
  BODY_TYPE = {
    "overweight": 2,
    "obese": 1,
    "underweight": 3,
    "normal": 0
  }

  SEX = {
    "female": 0,
    "male": 1
  }

  DIET = {
    "pescatarian": 1,
    "vegetarian": 3,
    "omnivore": 0,
    "vegan": 2
  }

  HOW_OFTEN_SHOWER = {
    "daily": 0,
    "less frequently": 1,
    "more frequently": 2,
    "twice a day": 3
  }

  HEATING_ENERGY_SOURCE = {
    "coal": 0,
    "natural gas": 2,
    "wood": 3,
    "electricity": 1
  }

  TRANSPORT = {
    "public": 1,
    "walk/bicycle": 2,
    "private": 0
  }

  VEHICLE_TYPE = {
    "empty": 0,
    "petrol": 5,
    "diesel": 1,
    "hybrid": 3,
    "lpg": 4,
    "electric": 2
  }

  SOCIAL_ACTIVITY = {
    "often": 1,
    "never": 0,
    "sometimes": 2
  }

  FREQUENCY_OF_TRAVEL_BY_AIR = {
    "frequently": 0,
    "rarely": 2,
    "never": 1,
    "very frequently": 3
  }

  WASTE_BAG_SIZE = {
    "large": 1,
    "extra large": 0,
    "small": 3,
    "medium": 2
  }

  ENERGY_EFFICIENCY = {
    "No": 0,
    "Sometimes": 1,
    "Yes": 2
  }

  RECYCLING = {
    "['Glass']" => 1,
    "['Metal']" => 2,
    "['Paper', 'Glass', 'Metal']" => 3,
    "['Paper', 'Glass']" => 4,
    "['Paper', 'Metal']" => 5,
    "['Paper', 'Plastic', 'Glass', 'Metal']" => 6,
    "['Paper', 'Plastic', 'Glass']" => 7,
    "['Paper', 'Plastic', 'Metal']" => 8,
    "['Paper', 'Plastic']" => 9,
    "['Paper']" => 10,
    "['Plastic', 'Glass', 'Metal']" => 11,
    "['Plastic', 'Glass']" => 12,
    "['Plastic', 'Metal']" => 13,
    "['Plastic']" => 14,
    "[]" => 15
  }

  COOKING_WITH = {
    "['Grill', 'Airfryer']" => 0,
    "['Microwave', 'Grill', 'Airfryer']" => 1,
    "['Microwave']" => 2,
    "['Oven', 'Grill', 'Airfryer']" => 3,
    "['Oven', 'Microwave', 'Grill', 'Airfryer']" => 4,
    "['Oven', 'Microwave']" => 5,
    "['Oven']" => 6,
    "['Stove', 'Grill', 'Airfryer']" => 7,
    "['Stove', 'Microwave', 'Grill', 'Airfryer']" => 8,
    "['Stove', 'Microwave']" => 9,
    "['Stove', 'Oven', 'Grill', 'Airfryer']" => 10,
    "['Stove', 'Oven', 'Microwave', 'Grill', 'Airfryer']" => 11,
    "['Stove', 'Oven', 'Microwave']" => 12,
    "['Stove', 'Oven']" => 13,
    "['Stove']" => 14,
    "[]" => 15
  }
end