# Plaid CTF 2014: PolygonShifter

**Category:** Web
**Points:** 100
**Description:**

> The Plague has purchased the newest invention, _Polygon Shifter_ to protect his website. This cutting edge technology is made available by Polygon Security, and they have a demo page on their [website](http://54.204.80.192/). They claim bots can no longer attack the website protected by the Polygon Shifter. Do we need to manually bruteforce the credentials?

## Write-up

Looking into sourcecode reveals that there is a secret admin account:

```html
<div class="row">
<div class="medium-10 small-centered columns">
    <h3>To demonstrate our technology, we have a form that is protected with our solution. Humans shall pass, but bots will FAIL.</h3>
    <h3>Test account is test / test</h3>
    <!--<h3>For admin interface, admin / ???????</h3>-->
</div>
</div>
```

Let's try to login with this admin account. We don't have the credentials, so we'll try some SQL injection instead.

Username: `admin' OR 'a'='a`
Password: `random`

Great, we can get in!

We are welcomed with the following message: 
`Hello, admin!! My password is the flag!`

Seems like we need to find the password with SQL injection. Let's peek into the sourcecode some more:

```html
<h4 class="product-header">A friendly login form; not so friendly for bots!</h4>
<div class="medium-11 small-centered columns">
    <form action="/P0zxeNVpdjH6myRHaWVS" method="POST">
        <label for="" style="text-align:left;">Username</label>
        <input type="text" id="6lyNestBnznos6FxGtGD" name="dVURHUzXGy69u5thdZY0">
        <label for="bFixmywlQhbkX1uC1oI2" style="text-align:left;">Password</label>
        <input type="password" id="bFixmywlQhbkX1uC1oI2" name="SU8IPPqzwozVlQzuaWSA">
        <input class="primary large" type="submit" value="Login">
    </form>
</div>
```

Okay, it seems that we cannot use the id's or names for these fields to automate the process. No problem, we don't really need those. The source code doesn't seem to have any more input fields, so we can just use the first and second input field to put our username and password in. 

```js
var arr = document.getElementsByTagName("input");
arr[0].value = "admin";
arr[1].value = "' or (password LIKE '%a%') and 1='1";
```

If we successfully log in as admin with these values, we know that our query succeeded and that there's an `a` in the password.

For the full script, see [the source](./client.js) (run the script as `phantomjs client.js "(password like 'a%')"`).

After some testing, we find that the flag is `n0b0t5_C4n_bYpa5s_p0lYm0rph1Sm`.

## Other write-ups

* <http://balidani.blogspot.com/2014/04/plaidctf-2014-polygonshifter-writeup.html>
* <https://ucs.fbi.h-da.de/writeup-plaidctf-2014-polygonshifter/>
