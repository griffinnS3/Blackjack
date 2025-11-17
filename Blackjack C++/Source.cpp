#include <iostream>
#include <cstring>  // ADD THIS - needed for strlen
using namespace std;

extern "C" void asmMain();

struct Card {
    char name[32];
    char suit[16];
    int value;
};

extern "C" {
    extern Card deck[52];
}

extern "C" void hitLoop(int* playerHand, int* dealerHand) {
    char input;
    cout << "Current hand value: " << *playerHand << endl;
    cout << "Dealer hand: " << *dealerHand << endl;
    cout << "Hit or stand (H or S): ";
    cin >> input;

    // You can expand this later
}

extern "C" void playGame() {
    char input;
    do {
        cout << "Would you like to play BlackJack? Press Y to start or N to exit: ";
        cin >> input;

        if (input == 'y' || input == 'Y') {
            asmMain();  // Start the game
            break;
        }
        else if (input == 'n' || input == 'N') {
            return;
        }
        else {
            cout << "Please enter Y to keep playing or N to exit" << endl;
        }
    } while (true);
}

int main() {
    asmMain();

    cout << "\nYour hand:" << endl;
    for (int i = 0; i < 2; i++) {
        cout << "  " << deck[i].name << " (Value: " << deck[i].value << ")" << endl;
    }

    cout << "\nDealer's hand:" << endl;
    for (int i = 2; i < 4; i++) {
        cout << "  " << deck[i].name << " (Value: " << deck[i].value << ")" << endl;
    }

    return 0;
}