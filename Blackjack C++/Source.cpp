#include <iostream>
using namespace std;
extern "C" void asmMain();

extern "C" void hitLoop(int d, int p, char i) {
	cout << "Current hand value: " << p;
	cout << "Dealer hand: " << d; 
	cout << "Hit or stand: (H or S): ";
	cin >> i;
	/*if (i == 'h' || i == 'H') {
	// add something later to call assembly functions
	}
	else if (i == 's' || i == 'S') {

	}
	else {
		cout << "please enter a valid value";
	}*/
}

int main() {
	asmMain();
	return 0;
}