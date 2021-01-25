const examples = require('mocha-each');
const expect = require('chai').expect
const libGreet = require('../src/index').libGreet


describe('index#libGreet()', () => {
  examples([
    ["pirate", "Yarr"],
    ["en", "Hello"],
    ["fr", "Bonjour"]
  ])
  .it('should greet in language %s', (language, expected) => {
    expect(libGreet(language)).to.eq(expected)
  });

  it("should use English by default", () => {
    expect(libGreet()).to.eq("Hello")
  })
})