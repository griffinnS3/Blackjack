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
extern "C" void playGame(char i) {
	do {
		cout << "Would you like to play BlackJack? Press Y to start playing or N to exit: ";
		cin >> i;
		if (i == 'y' || i == 'Y') {
			//Something to start the game
		}
		else if (i == 'n' || i == 'N') {
			exit;
		}
		else {
			cout << "Please enter Y to keep playing or N to exit";
		}
	} while (i != 'n' || i != 'N');
}

int main() {
	asmMain();
	return 0;
}