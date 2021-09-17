
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include<iomanip>
#include<string>
#include<cmath>
#include <ctime>
using namespace std;


// Assume max 100 order per day
extern "C"
{
	void startProgram();	//display Logo, carry out others function
	void HowToEat();		//Take away or dine in (Display input)
	void orderDetails();	//Display menu, Input order item and quantity, calculate grandTotal, store grandTotal for sales report
	void order();			//Display order details, calculate Total Sales
	void payment();			//Input Payment method. store payment method for sales report, input Payment Amount, calculate change
	void resit();			//Print Resit (With invNum, orderDetails, payment and change
	void displayReport();	//Display report - Sales Report and Rating Report
	void checkInvNum();
	void repeatInvNum();	//Only customer can rate for our shop
	void rating();			//Carry out rating module, input rating, calculate total number customer who have rate for our cafe, calculate the number of customer rate 1 star, 2 star, 3 star, 4 star or 5 star
	void repeatLogin();		//Exist when staff input invalid staff id and password, ask the  staff want to continue to login or exit program
	void login();			//Input staff ID, password(in hex), check password, valid or invalid
	//If user enter 3 times invalid staff id or password, user need to wait for 1 minute to continue
	//Exit the program after the staff view report



	void displayLogo();	//Shop Logo
	int input();		//Input to choose what module customer want to carry out
	int cusInput();
	void displayMenu();	//Display cafe's menu
	char meal();		//Choose wanna dine in or take away
	int inputOrder();	//Input  what item customer want to order
	int inputQuantity();		//Input quantity of the item
	void displayOrderHeader();	//Order Header
	void displayOrderDetails(int no, int cakeSelected, int quantity, int subTotal);	//Display all the order item 
	char addOrder();	//Customer want to add order item or not
	void displayGrandTotal(int x);	//Calulate and display grandTotal
	int inputPaymentMethod();		//Customer pay with Cash  and Credit Card
	int inputPaymentAmount(int paymentMethod, int grandTotal);	//Customer input payment amount
	void displayResitHeader(int invNum);				//Display Resit Header
	void displayPayment(int amountPaid, int change);	//Display change
	void displayReportDetails(int no, int storeInvNum, int storePaymentMethod, int storeGrandTotal);	//Display Report (Details of Sales Report)
	void displayReportHeader(int countOrder);	//Display report Header (For  sales report)
	void displaySalesTotal(int sales);	//Total sales amount
	int inputRating();	//Rating module (For customer to input the rating of our cafe)
	void calculatePercentage(int quotient, int remainder, int countTotalRating, int star);
	void displayRating(int countTotalRating, int count1, int count2, int count3, int count4, int count5, int countOrder);	//Display rating report
	void averageRating(int quotient, int remainder, int totalRating);

	char exitProgram();	//Continue with others module or exit the program
	char isStaff();		//Ask User is staff or not (If not a staff, cannot view report)
	int inputStaffID();	//Ask staff to input staff ID
	void displayInvalid();	//Display for user when useer enter invaid Staff ID and Password	
	char continueInput();  //Try again to input valid input 
}

int main()
{
	// Start program - select module to carry out
	startProgram();
	return 0;
}

void displayLogo()
{
	cout << "  ----------------  \n";
	cout << "  |   Wee Cafe   |  \n";
	cout << "  ----------------  \n";
	cout << endl;
	cout << "WELCOME TO WEE CAFE" << endl;
	cout << endl;

}

//Choose what module user want
int cusInput()
{
	int input;

	do
	{
		cout << "[1] Order " << endl;
		cout << "[2] Rating" << endl;
		cout << endl;

		cout << "Order[1] or Rating[2]: ";
		cin >> input;

		if (input < 1 || input > 2)
		{
			cout << "Invalid Input." << endl;
			cout << "Please enter again" << endl;
		}


	} while (input < 1 || input > 2);

	return input;

}

int input()
{
	int input;

	do
	{
		cout << "[1] Customer" << endl;
		cout << "[2] Staff" << endl;
		cout << "[3] Exit Program" << endl;
		cout << endl;


		cout << "Customer[1] or Staff[2] or Exit[3]: ";
		cin >> input;

		if (input < 1 || input > 3)
		{
			cout << "Invalid Input." << endl;
			cout << "Please enter again" << endl;
		}


	} while (input < 1 || input > 3);

	return input;

}

//Display menu
void displayMenu()
{
	cout << "  Menu \n";
	cout << "---------------------------------------------------------  \n";
	cout << "  |  Category  |      Name                |  Unit Price    \n";
	cout << "---------------------------------------------------------  \n";
	cout << "  |   Cakes    |   C[1]. Cheesecake       |     RM9 \n";
	cout << "  |            |   C[2]. Tiramisu         |     RM7 \n";
	cout << "  |            |   C[3]. Mille Crepe Cake |     RM9 \n";
	cout << "  |            |   C[4]. Brownies         |     RM8 \n";
	cout << "  |            |   C[5]. Chocolate Cake   |     RM6 \n";
	cout << "  |  Drinks    |   D[6]. Tea              |     RM3 \n";
	cout << "  |            |   D[7]. Latte            |     RM7 \n";
	cout << "  |            |   D[8]. Americano        |     RM5 \n";

	cout << endl;
}

//Take Away or Dine in
char meal()
{
	char meal;
	do
	{
		cout << "Take Away[T] or Dine In[D]: ";
		cin >> meal;
		meal = toupper(meal);

		if (meal != 'T' && meal != 'D')
		{
			cout << endl;
			cout << "Invalid Input." << endl;
			cout << "Please enter again. " << endl;
			cout << endl;
		}


	} while (meal != 'T' && meal != 'D');


	return meal;
}

//Get input from customer
int inputOrder()
{
	int itemNum;
	do
	{
		cout << "Select Item [1|2|3|4|5|6|7|8]: ";
		cin >> itemNum;

		if (itemNum < 1 || itemNum > 8)
		{
			cout << endl;
			cout << itemNum << "is a Invalid Input" << endl;
			cout << "Please enter again" << endl;
			cout << endl;
		}

	} while (itemNum < 1 || itemNum > 8);


	return itemNum;

}

//Input Quantity
int inputQuantity()
{
	int quantity;
	do
	{
		cout << "Quantity of Item Selected: ";
		cin >> quantity;

		if (quantity <= 0)
		{
			cout << endl;
			cout << "Invalid input" << endl;
			cout << "Please enter valid quantity of item" << endl;
			cout << endl;
		}

	} while (quantity <= 0);

	cout << endl;

	return quantity;
}

//Add Order
char addOrder()
{
	char respond;
	do
	{
		cout << "Add Order Item? Yes[Y]/ No[N] ";
		cin >> respond;
		respond = toupper(respond);

		if (respond != 'Y' && respond != 'N')
		{
			cout << endl;
			cout << "Invalid Input." << endl;
			cout << "Please enter again. " << endl;
			cout << endl;
		}

		cout << endl;

	} while (respond != 'Y' && respond != 'N');


	return respond;
}

//Select Payment Method
int inputPaymentMethod()
{
	int paymentMethod;
	do
	{
		cout << "Payment(Cash[1]/Credit Card[2]): ";
		cin >> paymentMethod;

		if (paymentMethod != 1 && paymentMethod != 2)
		{
			cout << "Invaid Input." << endl;
			cout << "Please enter again." << endl;
		}
	} while (paymentMethod != 1 && paymentMethod != 2);

	return paymentMethod;

}

void displayOrderHeader()
{
	cout << endl;
	cout << "Order Details" << endl;
	cout << "-------------";
	cout << endl;
	cout << left << setw(4) << "No";
	cout << left << setw(20) << "Cake Name";
	cout << left << setw(10) << "Quantity";
	cout << left << setw(10) << "Sub Total" << endl;

	cout << string(60, '-') << endl;
}

void displayOrderDetails(int no, int itemSelected, int quantity, int subTotal)
{
	string itemName;

	if (itemSelected == 1)
		itemName = "Cheese Cake";
	else if (itemSelected == 2)
		itemName = "Tiramisu";
	else if (itemSelected == 3)
		itemName = "Mille Crepe Cake";
	else if (itemSelected == 4)
		itemName = "Brownies";
	else if (itemSelected == 5)
		itemName = "Chocolate Cake";
	else if (itemSelected == 6)
		itemName = "Tea";
	else if (itemSelected == 7)
		itemName = "Latte";
	else if (itemSelected == 8)
		itemName = "Americano";



	cout << left << setw(4) << no;
	cout << left << setw(20) << itemName;
	cout << left << setw(10) << quantity;
	cout << left << setw(2) << " RM ";
	cout << left << setw(10) << subTotal << endl;
	cout << endl;


}

void displayGrandTotal(int x)
{
	cout << string(60, '-') << endl;
	cout << left << setw(35) << "Grand Total: ";
	cout << left << setw(2) << "RM ";
	cout << x << endl;
}

//Input Amount Pay
int inputPaymentAmount(int paymentMethod, int grandTotal)
{
	int amountPaid;

	if (paymentMethod == 1)
	{
		do
		{
			cout << "Amount Paid: ";
			cin >> amountPaid;

			if (amountPaid <= 0 || amountPaid < grandTotal)
			{
				cout << endl;
				cout << "Invalid Payment." << endl;
				cout << "Please enter again." << endl;
				cout << endl;
			}

		} while (amountPaid <= 0 || amountPaid < grandTotal);

	}
	else if (paymentMethod == 2)
		amountPaid = grandTotal;


	return amountPaid;

}


void displayResitHeader(int invNum)
{
	time_t timetoday;
	time(&timetoday);

	cout << endl;
	cout << "RECEIPT" << endl;
	cout << "-----" << endl;
	cout << endl;
	cout << "----------------" << endl;
	cout << "|   Wee Cafe   |" << endl;
	cout << "----------------" << endl;

	cout << left << setw(18) << "Order No" << left << setw(2) << ":" << invNum << endl;
	cout << left << setw(18) << "Date" << left << setw(2) << ":" << asctime(localtime(&timetoday));
	cout << left << setw(18) << "Payment Method" << left << setw(2) << ":";


}

void displayPayment(int amountPaid, int change)
{
	cout << left << setw(35) << "Amount Paid: ";
	cout << left << setw(2) << "RM ";
	cout << amountPaid << endl;
	cout << left << setw(35) << "";
	cout << left << setw(8) << string(8, '-') << endl;
	cout << left << setw(35) << "Change: ";
	cout << left << setw(2) << "RM ";
	cout << change << endl;
	cout << left << setw(35) << "";
	cout << left << setw(8) << string(8, '-') << endl;
	cout << endl;
}

void displayReportHeader(int countOrder)
{
	time_t timetoday;
	time(&timetoday);

	cout << endl;
	cout << "SALES REPORT" << endl;
	cout << "------------" << endl;

	cout << left << setw(18) << "Date" << left << setw(2) << ":" << asctime(localtime(&timetoday)) << endl;
	cout << left << setw(18) << "Number of order per day: " << left << setw(2) << ":" << countOrder << endl;
	cout << endl;



	cout << left << setw(4) << "No";
	cout << left << setw(10) << "InvNum";
	cout << left << setw(20) << "Payment Method";
	cout << left << setw(12) << "Grand Total" << endl;
	cout << string(60, '-') << endl;

}

void displayReportDetails(int no, int storeInvNum, int storePaymentMethod, int storeGrandTotal)
{
	string paymentMethod;

	if (storePaymentMethod == 1)
		paymentMethod = "Cash";
	else if (storePaymentMethod == 2)
		paymentMethod = "Credit Card";

	cout << left << setw(4) << no;
	cout << left << setw(10) << storeInvNum;
	cout << left << setw(20) << paymentMethod;
	cout << left << setw(2) << " RM ";
	cout << left << setw(10) << storeGrandTotal << endl;
}

void displaySalesTotal(int sales)
{
	cout << endl;
	cout << left << setw(35) << "";
	cout << left << setw(8) << string(8, '-') << endl;
	cout << left << setw(35) << "Total Sales: " << left << setw(4) << "RM ";
	cout << left << sales << endl;
	cout << left << setw(35) << "";
	cout << left << setw(8) << string(8, '-') << endl;
	cout << endl;
}

int inputRating()
{
	int rating;
	do
	{
		cout << endl;
		cout << "Select Rating [1|2|3|4|5]: ";
		cin >> rating;

		if (rating < 1 || rating > 5)
		{
			cout << endl;
			cout << rating << "is a Invalid Input" << endl;
			cout << "Please enter again" << endl;
			cout << endl;
		}

	} while (rating < 1 || rating > 5);

	cout << endl;
	cout << "Thank You!!!" << endl;
	cout << endl;
	return rating;

}

void calculatePercentage(int quotient, int remainder, int countTotalRating, int star)
{
	double percentage;
		
	if (remainder == 0)
		if (quotient == 0)
			percentage = 0;
		else
			percentage = 100;
	else
		percentage = (remainder/ (double)countTotalRating) * 100 + quotient;

	cout << "Average customer rating (%): " << star << " star : " << percentage << " %" << endl;

}


void displayRating(int countTotalRating, int count1, int count2, int count3, int count4, int count5, int countOrder)
{
	

	cout << "RATING REPORT" << endl;
	cout << "-------------" << endl;
	cout << "Number of Rating: " << countTotalRating << endl;
	cout << "Total customer rated 1 star: " << count1 << endl;
	cout << "Total customer rated 2 star: " << count2 << endl;
	cout << "Total customer rated 3 star: " << count3 << endl;
	cout << "Total customer rated 4 star: " << count4 << endl;
	cout << "Total customer rated 5 star: " << count5 << endl;
	cout << endl;

}

void averageRating(int quotient, int remainder, int totalRating)
{
	double average;
	if (remainder == 0)
		average = 100;
	else
		average = (remainder / (double)totalRating) * 100 + quotient;

	cout << "Average rating (%): " << average << " %";

}


char exitProgram()
{
	char exit;
	do
	{
		cout << "Continue? (Order/Rating/Staff Login) [Y] or Exit [N]";
		cin >> exit;
		exit = toupper(exit);

		if (exit != 'Y' && exit != 'N')
		{
			cout << "Invalid Input." << endl;
			cout << "Please enter again. " << endl;
		}

		cout << endl;

	} while (exit != 'Y' && exit != 'N');


	return exit;

}

char isStaff()
{
	char staff;
	do
	{
		cout << endl;
		cout << "Are you a staff?";
		cin >> staff;
		staff = toupper(staff);

		if (staff != 'Y' && staff != 'N')
		{
			cout << "Invalid Input." << endl;
			cout << "Please enter again. " << endl;
		}

		cout << endl;

	} while (staff != 'Y' && staff != 'N');


	return staff;

}

int inputStaffID()
{
	int id;

	cout << "Enter Staff ID: ";
	cin >> id;

	return id;
}

void displayInvalid()
{
	cout << endl;
	cout << "Invalid Staff ID and Password" << endl;
	cout << endl;
}

char continueInput()
{
	char respond;

	do
	{
		cout << "Do you want to try again ?";
		cin >> respond;
		respond = toupper(respond);

		if (respond != 'Y' && respond != 'N')
		{
			cout << "Invalid Input." << endl;
			cout << "Please enter again." << endl;
		}


	} while (respond != 'Y' && respond != 'N');

	return respond;

}
