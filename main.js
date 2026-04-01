// Create a simple calculator that can perform basic arithmetic operations (addition, subtraction, multiplication, division) on two numbers.
// Get references to the input fields and buttons
const num1Input = document.getElementById("num1");
const num2Input = document.getElementById("num2");
const addButton = document.getElementById("add");
const subtractButton = document.getElementById("subtract");
const multiplyButton = document.getElementById("multiply");
const divideButton = document.getElementById("divide");
const resultDisplay = document.getElementById("result");

// Function to perform the calculation
function calculate(operation) {
  const num1 = parseFloat(num1Input.value);
  const num2 = parseFloat(num2Input.value);
  let result;

  if (isNaN(num1) || isNaN(num2)) {
    resultDisplay.textContent = "Please enter valid numbers.";
    return;
  }

  switch (operation) {
    case "add":
      result = num1 + num2;
      break;
    case "subtract":
      result = num1 - num2;
      break;
    case "multiply":
      result = num1 * num2;
      break;
    case "divide":
      if (num2 === 0) {
        resultDisplay.textContent = "Cannot divide by zero.";
        return;
      }
      result = num1 / num2;
      break;
    default:
      resultDisplay.textContent = "Invalid operation.";
      return;
  }

  resultDisplay.textContent = `Result: ${result}`;
}

// Add event listeners to the buttons
addButton.addEventListener("click", () => calculate("add"));
subtractButton.addEventListener("click", () => calculate("subtract"));
multiplyButton.addEventListener("click", () => calculate("multiply"));
divideButton.addEventListener("click", () => calculate("divide"));
