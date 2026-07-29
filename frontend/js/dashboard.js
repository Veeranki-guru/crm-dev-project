// ========================================
// CRM-DEV - Dashboard JavaScript
// ========================================


// Run when page loads
document.addEventListener(
    "DOMContentLoaded",
    function () {

        console.log(
            "Dashboard Loaded"
        );


        // Load Dashboard Data
        loadDashboardData();


        // Logout Button
        const logoutButton =
            document.getElementById(
                "logoutButton"
            );


        // Check Logout Button
        if (logoutButton) {

            logoutButton.addEventListener(
                "click",
                logoutUser
            );

        }

    }
);


// ========================================
// Load Dashboard Data
// ========================================

async function loadDashboardData() {

    try {

        // Get Users
        const usersResponse =
            await fetch(
                "http://100.26.32.109:5000/users",
                {
                    credentials: "include"
                }
            );


        // Get Products
        const productsResponse =
            await fetch(
                "http://100.26.32.109:5000/products",
                {
                    credentials: "include"
                }
            );


        // Get Orders
        const ordersResponse =
            await fetch(
                "http://100.26.32.109:5000/orders",
                {
                    credentials: "include"
                }
            );


        // Convert Response to JSON
        const usersData =
            await usersResponse.json();

        const productsData =
            await productsResponse.json();

        const ordersData =
            await ordersResponse.json();


        // Update Dashboard
        document.getElementById(
            "totalUsers"
        ).textContent =
            usersData.length || 0;


        document.getElementById(
            "totalProducts"
        ).textContent =
            productsData.length || 0;


        document.getElementById(
            "totalOrders"
        ).textContent =
            ordersData.length || 0;


    } catch (error) {

        console.error(
            "Dashboard Error:",
            error
        );

    }

}


// ========================================
// Logout User
// ========================================

async function logoutUser() {

    try {

        const response =
            await fetch(
                "http://100.26.32.109:5000/auth/logout",
                {
                    method: "POST",

                    credentials: "include"
                }
            );


        if (response.ok) {

            alert(
                "Logout successful."
            );


            // Redirect to Login
            window.location.href =
                "login.html";

        } else {

            alert(
                "Logout failed."
            );

        }


    } catch (error) {

        console.error(
            "Logout Error:",
            error
        );

    }

}