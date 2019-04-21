// Author: Ivan Kazmenko (gassa@mail.ru)
// checker for problem "exact-calls"
module check;
import std.algorithm;
import std.conv;
import std.range;
import std.stdio;
import std.string;
import std.typecons;
import testlib;

immutable int minK =       1;
immutable int maxK = 10 ^^ 7;
immutable int minS =       1;
immutable int maxS =     100;
immutable int NA   =      -1;

long answer (ref InputFileStream f, int k)
{
	auto r = f.read !(int) (minS, maxS);
	auto c = f.read !(int) (minS, maxS);
	f.readln;
	auto board = new char [] [] (r, c);

	foreach (i; 0..r)
	{
		auto temp = f.readln.strip;
		if (temp.length != c || !temp.all !(x => ".x".canFind (x)))
		{
			f.quit (ExitCode.wa, "board row ", i + 1,
			    " not in proper format, must be [.x]{", c, "}");
		}
		foreach (j; 0..c)
		{
			board[i][j] = temp[j];
		}
	}

	outFile.checkEof ();

	auto boardCopy = board.map !(line => line.dup).array;

	auto total = r * c;
	alias Coord = Tuple !(int, q{i}, int, q{j});
	auto where = new Coord [total];
	foreach (i; 0..r)
	{
		foreach (j; 0..c)
		{
			auto z = i * c + j;
			where[z] = Coord (i, j);
		}
	}

	auto next = new int [total + 1];
	auto prev = new int [total + 1];
	foreach (z; 0..total + 1)
	{
		next[z] = (z + 1) % (total + 1);
		prev[z] = (z + total) % (total + 1);
	}

	void mark (int i, int j, char x)
	{
		board[i][j] = x;
		auto z = i * c + j;
		next[prev[z]] = next[z];
		prev[next[z]] = prev[z];
	}

	void unmark (int i, int j)
	{
		board[i][j] = '.';
		auto z = i * c + j;
		next[prev[z]] = z;
		prev[next[z]] = z;
	}

	foreach (i; 0..r)
	{
		foreach (j; 0..c)
		{
			if (board[i][j] == 'x')
			{
				mark (i, j, 'x');
			}
		}
	}

	long recurCalls = 0;

	bool recur ()
	{
		debug {writefln ("%-(%s\n%)\n", board);}
		recurCalls += 1;
		if (recurCalls > k)
		{
			return true;
		}

		auto z = next[total];
		if (z == total)
		{
			return true;
		}

		auto i = where[z].i;
		auto j = where[z].j;
		if (board[i][j] != '.')
		{
			assert (false);
		}

		if (j + 1 < c && board[i][j + 1] == '.')
		{
			mark (i, j, 'a');
			mark (i, j + 1, 'a');
			if (recur ())
			{
				return true;
			}
			unmark (i, j + 1);
			unmark (i, j);
		}

		if (i + 1 < r && board[i + 1][j] == '.')
		{
			mark (i, j, 'b');
			mark (i + 1, j, 'b');
			if (recur ())
			{
				return true;
			}
			unmark (i + 1, j);
			unmark (i, j);
		}

		return false;
	}

	if (!recur ())
	{
		recurCalls = NA;
	}

	debug {writefln ("%-(%s\n%)", board);}

	return recurCalls;
}

void main (string [] args)
{
	initTestlib !(TestlibRole.checker) (args);

	auto k = inFile.readFree !(int) ();

	auto cont = answer (outFile, k);
	if (cont == NA)
	{
		quit (ExitCode.wa, "board can not be covered");
	}
	else if (cont > k)
	{
		quit (ExitCode.wa, "expected ", k,
		    " calls, got at least ", cont);
	}
	else if (cont < k)
	{
		quit (ExitCode.wa, "expected ", k,
		    " calls, got only ", cont);
	}
	else if (cont == k)
	{
		quit (ExitCode.ok, cont, " calls");
	}
	else
	{
		assert (false);
	}
}
