// Author: Ivan Kazmenko (gassa@mail.ru)
// Generator for problem "exact-calls"
module gen;
import std.algorithm;
import std.conv;
import std.exception;
import std.format;
import std.random;
import std.range;
import std.stdio;

immutable string testFormat = "%03d";
enum generateAnswers = false;

immutable int minK =       1;
immutable int maxK = 10 ^^ 7;

struct Test
{
	int k;

	string comment;

	void validate () const
	{
		enforce (minK <= k && k <= maxK);
	}

	void print (File f) const
	{
		f.writeln (k);
	}

	string log () const
	{
		return format ("%s (k = %s)", comment, k);
	}
}

Test [] tests;

void printAllTests ()
{
	foreach (testNumber, test; tests)
	{
		test.validate ();
		auto testString = format (testFormat, testNumber + 1);
		auto f = File (testString, "wt");
		test.print (f);
		static if (generateAnswers)
		{
			auto g = File (testString ~ ".a", "wt");
			test.printAnswer (g);
		}
		writeln (testString, ": ", test.log ());
	}
}

Mt19937 rndLocal;
T rndValue (T) () {return uniform !(T) (rndLocal);}
T rndValue (T) (T lim) {return uniform (cast (T) (0), lim, rndLocal);}
T rndValue (T) (T lo, T hi) {return uniform (lo, hi, rndLocal);}
auto rndChoice (R) (R r) {return r[rndValue (cast (int) (r.length))];}

void rndShuffle (R) (R r)
{
	auto len = r.length.to !(int);
	foreach (i; 0..len)
	{
		int k = rndValue (i, len);
		r.swapAt (i, k);
	}
}

void main ()
{
	rndLocal.seed (123_246_499);

	tests ~= Test (14, "example test 1");
	tests ~= Test (2, "example test 2");

	int nt;

	nt = 0;
	foreach (ck; minK..minK + 11)
	{
		if (tests.canFind !(t => t.k == ck))
		{
			continue;
		}
		tests ~= Test (ck, format ("minimal test %s", nt + 1));
		nt += 1;
	}

	nt = 0;
	int prev = 15;
	while (true)
	{
		int next = prev * 5 / 4;
		if (next > maxK)
		{
			break;
		}
		auto ck = rndValue (prev, next);
		prev = next;
		if (tests.canFind !(t => t.k == ck))
		{
			continue;
		}
		tests ~= Test (ck, format ("random test %s", nt + 1));
		nt += 1;
	}

	tests ~= Test (40_955, "special test 1");
	tests ~= Test (2 ^^ 19 * 10 - 14, "special test 2");
	tests ~= Test (2 ^^ 12 * 60 - 18, "special test 3");
	tests ~= Test (3 ^^ 10 * 120 - 23, "special test 4");

	nt = 0;
	foreach (ck; maxK - 5..maxK + 1)
	{
		if (tests.canFind !(t => t.k == ck))
		{
			continue;
		}
		tests ~= Test (ck, format ("maximal test %s", nt + 1));
		nt += 1;
	}

	nt = 0;
	foreach (step; 0..5)
	{
		auto ck = rndValue (maxK / 10 * 0, maxK / 10 * 3) + 1;
		if (tests.canFind !(t => t.k == ck))
		{
			continue;
		}
		tests ~= Test (ck, format ("small random test %s", nt + 1));
		nt += 1;
	}

	nt = 0;
	foreach (step; 0..5)
	{
		auto ck = rndValue (maxK / 10 * 3, maxK / 10 * 7) + 1;
		if (tests.canFind !(t => t.k == ck))
		{
			continue;
		}
		tests ~= Test (ck, format ("medium random test %s", nt + 1));
		nt += 1;
	}

	nt = 0;
	foreach (step; 0..5)
	{
		auto ck = rndValue (maxK / 10 * 7, maxK / 10 * 10) + 1;
		if (tests.canFind !(t => t.k == ck))
		{
			continue;
		}
		tests ~= Test (ck, format ("large random test %s", nt + 1));
		nt += 1;
	}

	printAllTests ();
}
