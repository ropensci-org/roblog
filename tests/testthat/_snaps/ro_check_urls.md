# ro_check_urls works

    Code
      ro_check_urls(path)
    Message <rlang_message>
      * Wrong URLs, remove localhost part to create a relative URL: http://localhost:1313/blog.
      * Wrong URLs, slash missing: blog.
      * Possibly broken URLs: https://masalmon.eu/40004, https://masalmon.eu/400040, /4000004/.
      * Replace http with https for: http://masalmon.eu/.

---

    Code
      ro_check_urls(path)
    Message <rlang_message>
      v URLs ok!

