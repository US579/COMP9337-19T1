
const API_URL = 'http://192.168.1.102:5000';

const getJSON = (path, options) =>
    fetch(path, options)
        .then(res => res.json())
        .catch(err => console.warn(`API_ERROR: ${err.message}`));

class API {
    constructor(url = API_URL) {
        this.url = url;
    }

    makeAPIRequest(path, options) {
        return getJSON(`${this.url}/${path}`, options);
    }
}

const api  = new API();

const headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    "Access-Control-Allow-Methods": "DELETE, POST, GET, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With"
};
const method = 'GET';


const button = document.getElementById('login');
button.onclick = function() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    if (!username || !password){
        window.alert('Empty username or password! Try again.');
        return false;
    }


    const path = 'hack/'+ username + '/' + password;

    api.makeAPIRequest(path, {
        method, headers
    }).then(function (res) {
        console.log(res);
    });
};
