# Maybe move out to a lib/constants for now?
GENDERS = ['Male', 'Female']
EDUCATION = [
  "High School",
  "Some College",
  "Associate Degree",
  "Bachelor's Degree",
  "Master's Degree",
  "PhD / Post Doctoral",
  "Trade",
  "Other"
]

ETHNICITY = [
  "African-American",
  "Alaskan",
  "American Indian",
  "Asian",
  "Caucasian",
  "Hispanic / Latino",
  "Middle-Eastern",
  "Native American",
  "Pacific Islander",
  "Other"
]

RELIGIONS = [
  'African Traditional and Diasporic',
  'Agnostic',
  'Assemblies of God',
  'Baptist',
  'Cao Dai',
  'Catholic',
  'Chinese Traditional',
  'Christian',
  'Church of Latter-Day Saints (Mormon)',
  'Episcopalian',
  'Hinduism',
  'Islam',
  'Juche',
  'Judaism',
  'Lutheran (Evangelical)',
  'Lutheran (Missouri Synod)',
  'Methodist',
  'Neo-Paganism',
  'Non-Religious (Secular/Agnostic/Atheist)',
  'Presbyterian',
  'Primal-Indigenous',
  'Shinto',
  'Sikhism',
  'Spiritism',
  'Tenrikyo',
  'Unitarian-Universalism',
  'Zoroastrianism'
]

LIKES = [
  'Animals',
  'Books & Reading',
  'Career',
  'Education',
  'Family',
  'Health & Fitness',
  'Nightlife',
  'Outdoors',
  'Politics',
  'Religion',
  'Social Life',
  'Travel'
]

DISTANCES = [
  500,
  1000,
  2000,
  5000
]

DISTANCE_TYPES = [
  {name: 'Miles', value: 'mi'},
  {name: 'Kilometers', value: 'km'},
]

# needs to be migrated to models for easier config, but for expediency, done here.

class Question < Hashie::Dash
  property :question, :require => true
  property :value, :require => true
end

class ProfileQuestion < Hashie::Dash
  property :name, :require => true
  property :questions, default: []
end

q = Question.new
q.question = "Single / Never Married"
q.value = 0

pq = ProfileQuestion.new
pq.name = 'Marital Status'
pq.questions << q

PROFILE_DATA = pq



