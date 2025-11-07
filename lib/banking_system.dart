// Banking System OOP Challenge in Dart

// -------------------- Abstract Class --------------------
abstract class BankAccount {
  String _accountNumber;
  String _accountHolderName;
  double _balance;

  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  // Getters and setters for encapsulation
  String get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  double get balance => _balance;

  set accountHolderName(String name) => _accountHolderName = name;

  // Abstract methods
  void deposit(double amount);
  void withdraw(double amount);

  // Display account info
  void displayInfo() {
    print('Account Number: $_accountNumber');
    print('Holder Name: $_accountHolderName');
    print('Balance: \$${_balance.toStringAsFixed(2)}');
  }

  // Protected method to modify balance safely
  void updateBalance(double amount) {
    _balance += amount;
  }
}

// -------------------- Interface / Abstract Class --------------------
abstract class InterestBearing {
  void calculateInterest();
}

// -------------------- Savings Account --------------------
class SavingsAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 500.0;
  static const double interestRate = 0.02;
  static const int withdrawalLimit = 3;
  int _withdrawalCount = 0;

  SavingsAccount(String accNum, String holder, double balance)
      : super(accNum, holder, balance);

  @override
  void deposit(double amount) {
    if (amount > 0) {
      updateBalance(amount);
      print('Deposited \$${amount.toStringAsFixed(2)} to Savings Account');
    } else {
      print('Invalid deposit amount');
    }
  }

  @override
  void withdraw(double amount) {
    if (_withdrawalCount >= withdrawalLimit) {
      print('Withdrawal limit reached for this month!');
      return;
    }
    if (balance - amount >= minBalance) {
      updateBalance(-amount);
      _withdrawalCount++;
      print('Withdrew \$${amount.toStringAsFixed(2)} from Savings Account');
    } else {
      print('Cannot withdraw! Minimum balance requirement of \$500 not met.');
    }
  }

  @override
  void calculateInterest() {
    double interest = balance * interestRate;
    updateBalance(interest);
    print('Interest of \$${interest.toStringAsFixed(2)} added to Savings Account');
  }
}

// -------------------- Checking Account --------------------
class CheckingAccount extends BankAccount {
  static const double overdraftFee = 35.0;

  CheckingAccount(String accNum, String holder, double balance)
      : super(accNum, holder, balance);

  @override
  void deposit(double amount) {
    if (amount > 0) {
      updateBalance(amount);
      print('Deposited \$${amount.toStringAsFixed(2)} to Checking Account');
    } else {
      print('Invalid deposit amount');
    }
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < 0) {
      updateBalance(-amount - overdraftFee);
      print('Overdraft! Charged \$${overdraftFee.toStringAsFixed(2)} fee.');
    } else {
      updateBalance(-amount);
      print('Withdrew \$${amount.toStringAsFixed(2)} from Checking Account');
    }
  }
}

// -------------------- Premium Account --------------------
class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000.0;
  static const double interestRate = 0.05;

  PremiumAccount(String accNum, String holder, double balance)
      : super(accNum, holder, balance);

  @override
  void deposit(double amount) {
    if (amount > 0) {
      updateBalance(amount);
      print('Deposited \$${amount.toStringAsFixed(2)} to Premium Account');
    } else {
      print('Invalid deposit amount');
    }
  }

  @override
  void withdraw(double amount) {
    if (balance - amount >= minBalance) {
      updateBalance(-amount);
      print('Withdrew \$${amount.toStringAsFixed(2)} from Premium Account');
    } else {
      print('Cannot withdraw below minimum balance of \$10,000.');
    }
  }

  @override
  void calculateInterest() {
    double interest = balance * interestRate;
    updateBalance(interest);
    print('Interest of \$${interest.toStringAsFixed(2)} added to Premium Account');
  }
}

// -------------------- Extended System: Student Account --------------------
class StudentAccount extends BankAccount {
  static const double maxBalance = 5000.0;

  StudentAccount(String accNum, String holder, double balance)
      : super(accNum, holder, balance);

  @override
  void deposit(double amount) {
    if (balance + amount > maxBalance) {
      print('Deposit rejected! Maximum balance of \$5000 reached.');
    } else if (amount > 0) {
      updateBalance(amount);
      print('Deposited \$${amount.toStringAsFixed(2)} to Student Account');
    } else {
      print('Invalid deposit amount');
    }
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < 0) {
      print('Insufficient balance in Student Account.');
    } else {
      updateBalance(-amount);
      print('Withdrew \$${amount.toStringAsFixed(2)} from Student Account');
    }
  }
}

// -------------------- Bank Class --------------------
class Bank {
  final List<BankAccount> _accounts = [];

  void createAccount(BankAccount account) {
    _accounts.add(account);
    print('Account created for ${account.accountHolderName}');
  }

  BankAccount? findAccount(String accNumber) {
    try {
      return _accounts.firstWhere(
        (acc) => acc.accountNumber == accNumber,
      );
    } catch (e) {
      return null;
    }
  }

  void transfer(String fromAccNum, String toAccNum, double amount) {
    var fromAcc = findAccount(fromAccNum);
    var toAcc = findAccount(toAccNum);

    if (fromAcc == null || toAcc == null) {
      print('One or both accounts not found!');
      return;
    }

    fromAcc.withdraw(amount);
    toAcc.deposit(amount);
    print('Transferred \$${amount.toStringAsFixed(2)} from ${fromAcc.accountHolderName} to ${toAcc.accountHolderName}');
  }

  void applyMonthlyInterest() {
  for (var acc in _accounts) {
    if (acc is InterestBearing) {
      (acc as InterestBearing).calculateInterest();
    }
  }
}



  void generateReport() {
    print('\n===== Bank Report =====');
    for (var acc in _accounts) {
      acc.displayInfo();
      print('---------------------------');
    }
  }
}

// -------------------- Main Function --------------------
void main() {
  Bank bank = Bank();

  var acc1 = SavingsAccount('S001', 'roby', 1000);
  var acc2 = CheckingAccount('C001', 'bobby', 200);
  var acc3 = PremiumAccount('P001', 'lobby', 15000);
  var acc4 = StudentAccount('ST001', 'sobby', 3000);

  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);
  bank.createAccount(acc4);

  acc1.withdraw(200);
  acc2.withdraw(250);
  acc3.deposit(500);
  acc4.deposit(2500);

  bank.transfer('S001', 'C001', 100);
  bank.applyMonthlyInterest();

  bank.generateReport();
}
