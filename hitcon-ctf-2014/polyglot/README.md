# HITCON CTF 2014: polyglot

**Category:** Crazy
**Points:** 500
**Description:**

> Just `cat flag`
> http://210.61.2.47:8192/

**Hint:**

> Similar to DEFCON 22 quals polyglot, but ...
>
> Judge command:
>
> ```bash
> /usr/bin/python2.7 temp.py 2>/dev/null
> /usr/bin/python3.4 temp.py 2>/dev/null
> /usr/bin/gcc temp.c -o tempexe 2>/dev/null && tempexe 2>/dev/null
> /usr/bin/ruby temp.rb 2>/dev/null
> /usr/bin/runhaskell temp.hs 2>/dev/null
> ```

## Write-up

<https://gist.github.com/pyrocat101/c1c300c4d806513c1a56>

```
x = {-
#if 0
0 + """".to_i => 0}
print `cat flag`
__END__
""".find('x')}
import os
p = os.system;{
#endif
1};
#define p(s) main(){system(s);}
p("cat flag");
#define x // -}();main = do x <- readFile "flag"; putStr x
```

Explain line by line:

1. Create a Haskell function `x` and opening a Haskell block comment till the last line. The bracket also opens array literal in C, set literal in Python, and hash in Ruby.
2. Make gcc ignore line 2-9 with conditional compilation. It is also line comment in Python and Ruby.
3. `"""".to_i` returns 0 in Ruby, combining the first line it creates a hash `x = {-0 + 0 => 0}`. Because Python does not recognize hash rocket, the first three quotes `"""` creates a docstring till line 6.
4. Ruby code only. cat the flag.
5. Ruby code only. `__END__` indicates EOF to Ruby interpreter. 
6. Closes Python docstring. Combining with the first line Python interpreter reads `x = {-0 + """blahblah""".find('x')}`.
7. Python only
8. Assign `p` for C/Python polyglot at line 12. The trailing open bracket makes Python interpreter happy at line 10.
9. End of C conditional compilation.
10. Combining with line 1 this creates single-element array `x = {-1}` in C (ignore gcc warning). With line 8 Python reads `p = os.system;{1};`.
11. Define C macro for `main`.
12. Python/C polyglot to cat the flag.
13. Define macro `x` without body and `//` comments out the rest in gcc. '#' line comment in Python. What we left now is Haskell. Combining with the line 1 Haskell reads `x = ();`, which is a function `x` that returns unit. The rest of the line is Haskell main to cat the flag.

## Other write-ups

* <http://tasteless.se/2014/08/hitcon2014-polyglot-crazy500/>
