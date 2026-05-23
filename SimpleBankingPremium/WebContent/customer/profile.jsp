<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.simplebank.model.User" %>
<%@ include file="../includes/design.jspf" %>
<%
    User user = (User) request.getAttribute("user");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        .address-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }
        .current-address {
            padding: 12px 14px;
            border-radius: 16px;
            background: rgba(248, 250, 252, 0.9);
            border: 1px solid rgba(148, 163, 184, 0.18);
            color: #64748b;
            line-height: 1.5;
        }
        @media (max-width: 700px) {
            .address-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jspf" %>
    <main class="content">
        <div class="topbar">
            <div>
                <h1>Profile & Security</h1>
                <p>Update customer details, state, city and password.</p>
            </div>
        </div>
        <% if (success != null) { %><div class="alert success"><%= success %></div><% } %>
        <% if (error != null) { %><div class="alert error"><%= error %></div><% } %>
        <section class="grid-2">
            <form method="post" action="profile" class="panel form">
                <input type="hidden" name="action" value="profile">
                <input type="hidden" name="address" value="<%= user == null || user.getAddress() == null ? "" : user.getAddress() %>">
                <h2>Update Profile</h2>
                <label>Full Name</label>
                <input name="fullName" value="<%= user == null ? "" : user.getFullName() %>" required>
                <label>Phone</label>
                <input name="phone" value="<%= user == null || user.getPhone() == null ? "" : user.getPhone() %>">
                <label>Current Address</label>
                <div class="current-address"><%= user == null || user.getAddress() == null || user.getAddress().trim().isEmpty() ? "No address saved" : user.getAddress() %></div>
                <div class="address-grid">
                    <div>
                        <label>State / Union Territory</label>
                        <select id="profileState" name="state"><option value="">Keep current / Select State</option></select>
                    </div>
                    <div>
                        <label>City</label>
                        <select id="profileCity" name="city"><option value="">Keep current / Select City</option></select>
                    </div>
                </div>
                <label>House / Street / Area</label>
                <input name="addressLine" placeholder="Enter only if you want to update address">
                <button class="btn primary">Save Profile</button>
            </form>
            <form method="post" action="profile" class="panel form">
                <input type="hidden" name="action" value="password">
                <h2>Change Password</h2>
                <label>Old Password</label>
                <input type="password" name="oldPassword" required>
                <label>New Password</label>
                <input type="password" name="newPassword" minlength="6" required>
                <button class="btn secondary">Change Password</button>
            </form>
        </section>
    </main>
</div>
<script>
    const indianCities = {
        "Andhra Pradesh": ["Visakhapatnam", "Vijayawada", "Guntur", "Nellore", "Tirupati", "Kurnool", "Rajahmundry", "Kakinada", "Anantapur", "Kadapa", "Other"],
        "Arunachal Pradesh": ["Itanagar", "Naharlagun", "Pasighat", "Tawang", "Ziro", "Bomdila", "Other"],
        "Assam": ["Guwahati", "Silchar", "Dibrugarh", "Jorhat", "Tezpur", "Nagaon", "Tinsukia", "Bongaigaon", "Other"],
        "Bihar": ["Patna", "Gaya", "Bhagalpur", "Muzaffarpur", "Darbhanga", "Purnia", "Arrah", "Begusarai", "Katihar", "Other"],
        "Chhattisgarh": ["Raipur", "Bhilai", "Bilaspur", "Korba", "Durg", "Rajnandgaon", "Jagdalpur", "Other"],
        "Goa": ["Panaji", "Margao", "Vasco da Gama", "Mapusa", "Ponda", "Other"],
        "Gujarat": ["Ahmedabad", "Surat", "Vadodara", "Rajkot", "Gandhinagar", "Bhavnagar", "Jamnagar", "Junagadh", "Anand", "Other"],
        "Haryana": ["Gurugram", "Faridabad", "Panipat", "Ambala", "Hisar", "Karnal", "Rohtak", "Sonipat", "Yamunanagar", "Other"],
        "Himachal Pradesh": ["Shimla", "Dharamshala", "Mandi", "Solan", "Kullu", "Hamirpur", "Bilaspur", "Other"],
        "Jharkhand": ["Ranchi", "Jamshedpur", "Dhanbad", "Bokaro", "Deoghar", "Hazaribagh", "Giridih", "Other"],
        "Karnataka": ["Bengaluru", "Mysuru", "Mangaluru", "Hubballi", "Belagavi", "Kalaburagi", "Davanagere", "Ballari", "Udupi", "Other"],
        "Kerala": ["Thiruvananthapuram", "Kochi", "Kozhikode", "Thrissur", "Kollam", "Alappuzha", "Kannur", "Palakkad", "Kottayam", "Other"],
        "Madhya Pradesh": ["Bhopal", "Indore", "Jabalpur", "Gwalior", "Ujjain", "Sagar", "Rewa", "Satna", "Ratlam", "Other"],
        "Maharashtra": ["Mumbai", "Pune", "Nagpur", "Nashik", "Thane", "Chhatrapati Sambhajinagar", "Solapur", "Kolhapur", "Amravati", "Navi Mumbai", "Other"],
        "Manipur": ["Imphal", "Thoubal", "Bishnupur", "Churachandpur", "Kakching", "Other"],
        "Meghalaya": ["Shillong", "Tura", "Jowai", "Nongstoin", "Williamnagar", "Other"],
        "Mizoram": ["Aizawl", "Lunglei", "Champhai", "Serchhip", "Kolasib", "Other"],
        "Nagaland": ["Kohima", "Dimapur", "Mokokchung", "Tuensang", "Wokha", "Mon", "Other"],
        "Odisha": ["Bhubaneswar", "Cuttack", "Rourkela", "Berhampur", "Sambalpur", "Puri", "Balasore", "Other"],
        "Punjab": ["Ludhiana", "Amritsar", "Jalandhar", "Patiala", "Bathinda", "Mohali", "Hoshiarpur", "Pathankot", "Other"],
        "Rajasthan": ["Jaipur", "Jodhpur", "Udaipur", "Kota", "Bikaner", "Ajmer", "Alwar", "Bharatpur", "Sikar", "Other"],
        "Sikkim": ["Gangtok", "Namchi", "Gyalshing", "Mangan", "Rangpo", "Other"],
        "Tamil Nadu": ["Chennai", "Coimbatore", "Madurai", "Tiruchirappalli", "Salem", "Tirunelveli", "Erode", "Vellore", "Thoothukudi", "Other"],
        "Telangana": ["Hyderabad", "Warangal", "Nizamabad", "Karimnagar", "Khammam", "Ramagundam", "Mahbubnagar", "Other"],
        "Tripura": ["Agartala", "Udaipur", "Dharmanagar", "Kailashahar", "Ambassa", "Other"],
        "Uttar Pradesh": ["Lucknow", "Kanpur", "Varanasi", "Agra", "Prayagraj", "Ghaziabad", "Noida", "Meerut", "Gorakhpur", "Bareilly", "Aligarh", "Other"],
        "Uttarakhand": ["Dehradun", "Haridwar", "Roorkee", "Haldwani", "Rudrapur", "Rishikesh", "Nainital", "Other"],
        "West Bengal": ["Kolkata", "Howrah", "Durgapur", "Asansol", "Siliguri", "Bardhaman", "Kharagpur", "Malda", "Other"],
        "Andaman and Nicobar Islands": ["Port Blair", "Mayabunder", "Diglipur", "Rangat", "Other"],
        "Chandigarh": ["Chandigarh", "Other"],
        "Dadra and Nagar Haveli and Daman and Diu": ["Daman", "Diu", "Silvassa", "Other"],
        "Delhi": ["New Delhi", "Central Delhi", "North Delhi", "South Delhi", "East Delhi", "West Delhi", "Dwarka", "Rohini", "Other"],
        "Jammu and Kashmir": ["Srinagar", "Jammu", "Anantnag", "Baramulla", "Udhampur", "Kathua", "Other"],
        "Ladakh": ["Leh", "Kargil", "Other"],
        "Lakshadweep": ["Kavaratti", "Agatti", "Amini", "Minicoy", "Other"],
        "Puducherry": ["Puducherry", "Karaikal", "Mahe", "Yanam", "Other"]
    };

    function populateStateCity(stateId, cityId) {
        const stateSelect = document.getElementById(stateId);
        const citySelect = document.getElementById(cityId);
        if (!stateSelect || !citySelect) return;
        Object.keys(indianCities).forEach(function (state) {
            const option = document.createElement('option');
            option.value = state;
            option.textContent = state;
            stateSelect.appendChild(option);
        });
        stateSelect.addEventListener('change', function () {
            citySelect.innerHTML = '<option value="">Select City</option>';
            (indianCities[stateSelect.value] || []).forEach(function (city) {
                const option = document.createElement('option');
                option.value = city;
                option.textContent = city;
                citySelect.appendChild(option);
            });
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        populateStateCity('state', 'city');
        populateStateCity('profileState', 'profileCity');
    });
</script>
</body>
</html>
