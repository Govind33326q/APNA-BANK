<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Account - Premium Bank</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@ include file="includes/design.jspf" %>
    <style>
        .register-page {
            min-height: 100vh;
            padding: 34px 18px;
            display: grid;
            place-items: center;
            background:
                radial-gradient(circle at 14% 12%, rgba(37,99,235,.12), transparent 25rem),
                radial-gradient(circle at 90% 12%, rgba(6,182,212,.11), transparent 23rem),
                linear-gradient(135deg, #f8fbff, #edf5ff 48%, #ffffff);
        }
        .register-shell {
            width: min(1120px, 100%);
            display: grid;
            grid-template-columns: 0.92fr 1.08fr;
            gap: 24px;
            align-items: stretch;
        }
        .onboarding-scene,
        .register-panel {
            border-radius: 34px;
            background: rgba(255,255,255,.76);
            border: 1px solid rgba(255,255,255,.86);
            box-shadow: 0 28px 90px rgba(15,23,42,.12);
            backdrop-filter: blur(22px);
            overflow: hidden;
            position: relative;
        }
        .onboarding-scene {
            min-height: 650px;
            padding: 30px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .onboarding-scene::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                linear-gradient(135deg, rgba(37,99,235,.09), transparent),
                radial-gradient(circle at 68% 22%, rgba(6,182,212,.16), transparent 14rem);
        }
        .scene-content,
        .kyc-stage {
            position: relative;
            z-index: 2;
        }
        .scene-content h1 {
            margin: 0 0 12px;
            font-size: clamp(32px, 4vw, 54px);
            line-height: 0.98;
            letter-spacing: -0.075em;
            color: #07111f;
        }
        .scene-content p {
            color: #64748b;
            line-height: 1.7;
            max-width: 420px;
        }
        .kyc-stage {
            height: 360px;
        }
        .desk-3d {
            position: absolute;
            left: 35px;
            right: 35px;
            bottom: 28px;
            height: 82px;
            border-radius: 28px;
            background: linear-gradient(135deg, #ffffff, #dbeafe);
            border: 1px solid rgba(255,255,255,.95);
            box-shadow: 0 30px 60px rgba(15,23,42,.15);
            transform: perspective(900px) rotateX(58deg);
        }
        .document-stack {
            position: absolute;
            left: 56px;
            bottom: 100px;
            width: 190px;
            height: 130px;
            transform: perspective(900px) rotateY(-14deg) rotateX(4deg);
            animation: paperFloat 3s ease-in-out infinite alternate;
        }
        .doc-page {
            position: absolute;
            width: 150px;
            height: 104px;
            border-radius: 18px;
            background: rgba(255,255,255,.95);
            border: 1px solid rgba(148,163,184,.22);
            box-shadow: 0 18px 36px rgba(15,23,42,.12);
        }
        .doc-page:nth-child(1) { left: 0; top: 18px; transform: rotate(-8deg); }
        .doc-page:nth-child(2) { left: 24px; top: 8px; transform: rotate(4deg); }
        .doc-page:nth-child(3) { left: 46px; top: 0; transform: rotate(10deg); }
        .doc-page::before,
        .doc-page::after {
            content: "";
            position: absolute;
            left: 18px;
            right: 22px;
            height: 8px;
            border-radius: 999px;
            background: #dbeafe;
        }
        .doc-page::before { top: 28px; }
        .doc-page::after { top: 50px; width: 58%; }
        .approval-stamp {
            position: absolute;
            right: 32px;
            bottom: 110px;
            width: 126px;
            height: 126px;
            border-radius: 32px;
            display: grid;
            place-items: center;
            color: #166534;
            background: rgba(220,252,231,.9);
            border: 1px solid rgba(22,163,74,.18);
            box-shadow: 0 24px 52px rgba(22,163,74,.14);
            transform: perspective(800px) rotateY(-12deg) rotateX(8deg);
            animation: stampPop 2.8s ease-in-out infinite;
        }
        .approval-stamp b { display: block; font-size: 34px; text-align: center; }
        .approval-stamp span { display: block; font-size: 11px; text-transform: uppercase; letter-spacing: .12em; font-weight: 900; }
        .register-card-3d {
            position: absolute;
            left: 120px;
            bottom: 54px;
            width: 270px;
            min-height: 164px;
            padding: 20px;
            border-radius: 28px;
            color: white;
            background: linear-gradient(135deg, #0f172a, #2563eb 60%, #06b6d4);
            box-shadow: 0 28px 70px rgba(37,99,235,.28);
            transform: perspective(1000px) rotateY(-16deg) rotateX(8deg);
            animation: cardEntrance 2.4s cubic-bezier(.2,.8,.2,1) both;
        }
        .reg-chip { width: 48px; height: 34px; border-radius: 11px; background: linear-gradient(135deg, #fde68a, #f59e0b); }
        .reg-card-number { margin-top: 42px; font-size: 20px; letter-spacing: .13em; font-weight: 900; }
        .reg-card-meta { margin-top: 18px; display: flex; justify-content: space-between; color: #dbeafe; font-size: 11px; text-transform: uppercase; font-weight: 900; }
        @keyframes paperFloat {
            from { transform: perspective(900px) rotateY(-14deg) rotateX(4deg) translateY(0); }
            to { transform: perspective(900px) rotateY(-10deg) rotateX(8deg) translateY(-10px); }
        }
        @keyframes stampPop {
            0%, 100% { transform: perspective(800px) rotateY(-12deg) rotateX(8deg) scale(1); }
            50% { transform: perspective(800px) rotateY(-8deg) rotateX(5deg) scale(1.06); }
        }
        @keyframes cardEntrance {
            from { opacity: 0; transform: perspective(1000px) rotateY(-40deg) rotateX(12deg) translateY(60px); }
            to { opacity: 1; transform: perspective(1000px) rotateY(-16deg) rotateX(8deg) translateY(0); }
        }
        .register-panel { padding: 34px; }
        .register-panel h1 { margin: 20px 0 10px; font-size: clamp(30px, 4vw, 48px); letter-spacing: -0.07em; line-height: 1; }
        .register-panel p { color: #64748b; line-height: 1.7; }
        .address-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        textarea { resize: vertical; min-height: 72px; }
        @media (max-width: 950px) { .register-shell { grid-template-columns: 1fr; } .onboarding-scene { min-height: 520px; } }
        @media (max-width: 640px) { .register-panel { padding: 22px; } .address-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body class="register-page">
<div class="register-shell">
    <section class="onboarding-scene">
        <div class="scene-content">
            <a href="index.jsp" class="btn secondary">← Back to Home</a>
            <h1>Create your customer account</h1>
            <p>Your request will go to the bank team for approval. After approval, banking features become available.</p>
        </div>
        <div class="kyc-stage">
            <div class="desk-3d"></div>
            <div class="document-stack"><div class="doc-page"></div><div class="doc-page"></div><div class="doc-page"></div></div>
            <div class="approval-stamp"><div><b>✓</b><span>Verify</span></div></div>
            <div class="register-card-3d"><div class="reg-chip"></div><div class="reg-card-number">4508 2210</div><div class="reg-card-meta"><span>Premium</span><span>Account</span></div></div>
        </div>
    </section>

    <section class="register-panel">
        <div class="brand-mark">AB</div>
        <h1>Account application</h1>
        <p>Fill the details carefully. Address uses state and city dropdowns for clear customer records.</p>
        <% if (error != null) { %><div class="alert error"><%= error %></div><% } %>
        <form action="register" method="post" class="form grid-form">
            <div><label>Full Name</label><input type="text" name="fullName" required></div>
            <div><label>Email</label><input type="email" name="email" required></div>
            <div><label>Password</label><input type="password" name="password" minlength="6" required></div>
            <div><label>Phone</label><input type="text" name="phone"></div>
            <div><label>Account Type</label><select name="accountType"><option value="SAVINGS">Savings</option><option value="CURRENT">Current</option></select></div>
            <div><label>State / Union Territory</label><select id="state" name="state" required><option value="">Select State</option></select></div>
            <div><label>City</label><select id="city" name="city" required><option value="">Select City</option></select></div>
            <div><label>House / Street / Area</label><input type="text" name="addressLine" placeholder="Flat, street, area"></div>
            <button type="submit" class="btn primary full grid-full">Submit Application</button>
        </form>
        <div class="switch-link">Already registered? <a href="login.jsp">Login</a></div>
    </section>
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
