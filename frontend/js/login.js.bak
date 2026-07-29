// ========================================
// CRM-DEV - Login JavaScript
// ========================================


// Get Login Form
const loginForm = document.getElementById("loginForm");


// Get Error Message Element
const errorMessage = document.getElementById("errorMessage");


// Check if Login Form Exists
if (loginForm) {

    loginForm.addEventListener(
        "submit",
        async function (event) {

            // Stop normal form submission
            event.preventDefault();


            // Get Email
            const email =
                document.getElementById("email")
                    .value
                    .trim();


            // Get Password
            const password =
                document.getElementById("password")
                    .value
                    .trim();


            // Clear Previous Error
            errorMessage.textContent = "";


            // Validate Email
            if (email === "") {

                errorMessage.textContent =
                    "Please enter your email.";

                return;
            }


            // Validate Password
            if (password === "") {

                errorMessage.textContent =
                    "Please enter your password.";

                return;
            }


            // Validate Password Length
            if (password.length < 6) {

                errorMessage.textContent =
                    "Password must be at least 6 characters.";

                return;
            }


            // Login API Request
            try {

                const response = await fetch(
                    "http://localhost:5000/auth/login",
                    {
                        method: "POST",

                        headers: {
                            "Content-Type":
                                "application/json"
                        },

                        credentials: "include",

                        body: JSON.stringify({
                            email: email,
                            password: password
                        })
                    }
                );


                // Convert Response to JSON
                const data =
                    await response.json();


                // Check Login Result
                if (response.ok) {

                    alert(
                        "Login successful!"
                    );


                    // Redirect to Dashboard
                    window.location.href =
                        "dashboard.html";

                } else {

                    errorMessage.textContent =
                        data.message ||
                        "Invalid email or password.";

                }


            } catch (error) {

                console.error(
                    "Login Error:",
                    error
                );


                errorMessage.textContent =
                    "Unable to connect to server.";

            }

        }
    );

}