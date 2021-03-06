// Author: Ivan Kazmenko (gassa@mail.ru)
module solution;
import std.algorithm;
import std.conv;
import std.range;
import std.stdio;

immutable int minS  =   1;
immutable int maxS  = 100;
immutable int limit =  25;

char [] [] solve (int k)
{
	auto board = new char [] [] (maxS, maxS);
	foreach (ref line; board)
	{
		line[] = 'x';
	}

	k -= 1;

	int row = 0;
	foreach_reverse (p; 1..limit)
	{
		auto add = (5 << p) - 5;
		while (k >= add)
		{
			foreach (i; 0..p)
			{
				board[row + 0][i * 5 + 0] = '.';
				board[row + 0][i * 5 + 1] = '.';
				board[row + 0][i * 5 + 2] = '.';
				board[row + 0][i * 5 + 3] = '.';
				board[row + 1][i * 5 + 0] = '.';
				board[row + 1][i * 5 + 3] = '.';
			}
			row += 3;
			k -= add;
		}
	}

	int col = 0;
	while (k > 0)
	{
		board[row][col] = '.';
		col += 1;
		board[row][col] = '.';
		col += 1;
		k -= 1;
	}

	return board;
}

void main ()
{
	int k;
	while (readf (" %s", &k) > 0)
	{
		auto res = solve (k);
		writeln (res.length, " ", res.front.length);
		writefln ("%-(%s\n%)", res);
	}
}
