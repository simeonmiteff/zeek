# @TEST-EXEC: zeek -b %INPUT >out
# @TEST-EXEC: btest-diff out
# @TEST-EXEC: btest-diff .stderr

function test_case(msg: string, expect: bool)
        {
        print fmt("%s (%s)", msg, expect ? "PASS" : "FAIL");
        }

global i1: int = 3;
global i2: int = +3;
global i3: int = -3;
global i4: int = +0;
global i5: int = -0;
global i6: int = 12;
global i7: int = +0xc;
global i8: int = 0xC;
global i9: int = -0xC;
global i10: int = -12;
global i11: int = 9223372036854775807;   # max. allowed value
global i12: int = -9223372036854775808;  # min. allowed value
global i13: int = 0x7fffffffffffffff;   # max. allowed value
global i14: int = -0x8000000000000000;  # min. allowed value
global i15 = +3;

event zeek_init()
{
	# Type inference test

	test_case( "type inference", type_name(i15) == "int" );

	# Test various constant representations

	test_case( "optional '+' sign", i1 == i2 );
	test_case( "negative vs. positive", i1 != i3 );
	test_case( "negative vs. positive", i4 == i5 );
	test_case( "hexadecimal", i6 == i7 );
	test_case( "hexadecimal", i6 == i8 );
	test_case( "hexadecimal", i9 == i10 );

	# Operator tests

	test_case( "relational operator", i2 > i3 );
	test_case( "relational operator", i2 >= i3 );
	test_case( "relational operator", i3 < i2 );
	test_case( "relational operator", i3 <= i2 );
	test_case( "absolute value", |i4| == 0 );
	test_case( "absolute value", |i3| == 3 );
	test_case( "pre-increment operator", ++i2 == 4 );
	test_case( "pre-decrement operator", --i2 == 3 );
	test_case( "modulus operator", i2%2 == 1 );
	test_case( "division operator", i2/2 == 1 );
	i2 += 4;
	test_case( "assignment operator", i2 == 7 );
	i2 -= 2;
	test_case( "assignment operator", i2 == 5 );
	test_case( "bitwise lshift", i6 << 1 == 24 );
	test_case( "bitwise rshift", i6 >> 1 == 6 );

	# Max/min value tests

	local str1 = fmt("max int value = %d", i11);
	test_case( str1, str1 == "max int value = 9223372036854775807" );
	local str2 = fmt("min int value = %d", i12);
	test_case( str2, str2 == "min int value = -9223372036854775808" );
	local str3 = fmt("max int value = %d", i13);
	test_case( str3, str3 == "max int value = 9223372036854775807" );
	local str4 = fmt("min int value = %d", i14);
	test_case( str4, str4 == "min int value = -9223372036854775808" );
}
