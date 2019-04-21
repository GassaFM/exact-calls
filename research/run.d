import std.stdio;
import std.string;

auto numCalls (int rows, int cols, char [] [] board)
{
	long res = 0;

	bool recur ()
	{
		res += 1;
		foreach (row; 0..rows)
		{
			foreach (col; 0..cols)
			{
				if (board[row][col] == '.')
				{
					if (col + 1 < cols &&
					    board[row][col + 1] == '.')
					{
						board[row][col] = 'a';
						board[row][col + 1] = 'a';
						if (recur ())
						{
							return true;
						}
						board[row][col + 1] = '.';
						board[row][col] = '.';
					}

					if (row + 1 < rows &&
					    board[row + 1][col] == '.')
					{
						board[row][col] = 'b';
						board[row + 1][col] = 'b';
						if (recur ())
						{
							return true;
						}
						board[row + 1][col] = '.';
						board[row][col] = '.';
					}

					return false;
				}
			}
		}
		return true;
	}

	if (recur ())
	{
		debug {writefln ("%-(%s\n%)", board);}
		return res;
	}
	else
	{
		return -1;
	}
}

void main ()
{
	int rows;
	int cols;
	while (readf (" %s %s", &rows, &cols) > 0)
	{
		readln;
		char [] [] board;
		board.reserve (rows);
		foreach (row; 0..rows)
		{
			board ~= readln.strip.dup;
		}
		writeln (numCalls (rows, cols, board));
	}
}
