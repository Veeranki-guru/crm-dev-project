// Login page JavaScript

document.addEventListener("DOMContentLoaded", function () {

    // Get login form
    const loginForm = document.getElementById("loginForm");

    // Get password input
    const passwordInput = document.getElementById("password");

    // Get password toggle button
    const togglePassword = document.getElementById("togglePassword");

    // Get error message element
    const errorMessage = document.getElementById("errorMessage");


    // Show / Hide password
    if (togglePassword) {

        togglePassword.addEventListener("click", function () {

            if (passwordInput.type === "password") {

                passwordInput.type = "text";

                togglePassword.textContent = "Hide";

            } else {

                passwordInput.type = "password";

                togglePassword.textContent = "Show";
            }
        });
    }


    // Login form validation
    if (loginForm) {

        loginForm.addEventListener("submit", function (event) {

            const email = document
                .getElementById("email")
                .value
                .trim();

            const password = passwordInput
                .value
                .trim();


            // Clear previous error
            if (errorMessage) {
                errorMessage.textContent = "";
            }


            // Check email
            if (email === "") {

                event.preventDefault();

                showError("Please enter your email");

                return;
            }


            // Check password
            if (password === "") {

                event.preventDefault();

                showError("Please enter your password");

                return;
            }


            // Check password length
            if (password.length < 6) {

                event.preventDefault();

                showError(
                    "Password must contain at least 6 characters"
                );

                return;
            }

        });
    }


    // Display error message
    function showError(message) {

        if (errorMessage) {

            errorMessage.textContent = message;

        } else {

            alert(message);
        }
    }

});