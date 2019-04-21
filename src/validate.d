// Author: Ivan Kazmenko (gassa@mail.ru)
// Validator for problem "exact-calls"
module validate;
import testlib;

immutable int minK =       1;
immutable int maxK = 10 ^^ 7;

void main (string [] args)
{
	initTestlib !(TestlibRole.validator) (args);

	auto k = inFile.read !(int) (minK, maxK);
	inFile.skip ("\n");

	inFile.checkEof ();
}
