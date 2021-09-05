"use strict";

var connection = new signalR.HubConnectionBuilder().withUrl("/loginHub").build();

//Disable send button until connection is established
//document.getElementById("sendButton").disabled = true;

connection.on("LoginResult", function (message) {
    window.location.href = "/dashboard";
});

connection.start().then(function () {
    console.log(connection.connectionId);
}).catch(function (err) {
    return console.error(err.toString());
});

document.getElementById("submitBtn").addEventListener("click", function (event) {
    var email = document.getElementById("email");
    var password = document.getElementById("password");

    email.disabled = true;
    password.disabled = true;
    document.getElementById("submitBtn").classList.add("d-none");
    document.getElementById("spinner").classList.remove("d-none");
    connection.invoke("RequestLogin", email.value, password.value).catch(function (err) {
        document.getElementById("submitBtn").classList.remove("d-none");
        document.getElementById("spinner").classList.add("d-none");
        return console.error(err.toString());

    });
    event.preventDefault();
});