function libGreet(language){
  switch(language){
    case "pirate": return "Yarr"
    case "fr": return "Bonjour"
    case "en": 
    default:
      return "Hello" 
  }
}

module.exports={
  libGreet
}