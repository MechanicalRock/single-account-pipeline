const greet = require('../src/index').greet
const expect = require('chai').expect
// import { greet } from '../src/index'
// import { expect } from 'chai'

describe("index#greet()", () => {
  it("should give a greeting", () => {
    expect(greet()).to.equal("Hello World!")
  })
})