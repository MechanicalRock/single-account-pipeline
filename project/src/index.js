const libGreet = require('@internal/project_dependency').libGreet
function greet() {
  return `${libGreet()} World!`;
}

module.exports = {
  greet,
};
