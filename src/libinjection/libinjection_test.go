package libinjection

import (
	"testing"
	//"log"
	"net/url"
)

type testCase struct {
	sqli string
	encoded bool
}
	

func TestIsSqli(t *testing.T) {
	cases := []testCase {
		{"asdf asd ; -1' and 1=1 union/* foo */select load_file('/etc/passwd')--", false},
		{`/form.php?q=1'%20and%201=1%20+UNION+SELECT+VERSION%28%29`, true},
	}
	for _, c := range cases {
		t.Logf("Got sqli input: '%s'", c.sqli)
		if c.encoded {
			c.sqli, _ = url.QueryUnescape(c.sqli)
		}	
		t.Logf("%d\n", IsSqli(c.sqli))
	}
}
