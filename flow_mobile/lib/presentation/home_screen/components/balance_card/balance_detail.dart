import 'package:flow_mobile/presentation/home_screen/components/balance_card/balance_data.dart';
import 'package:flutter/widgets.dart';

class BalanceDetail extends StatelessWidget {
  const BalanceDetail({super.key, required this.balanceData});

  final BalanceData balanceData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IncomeContainer(balanceData: balanceData),
        SpendingContainer(balanceData: balanceData),
        TotalBalanceContainer(balanceData: balanceData),
      ],
    );
  }
}

class IncomeContainer extends StatelessWidget {
  const IncomeContainer({super.key, required this.balanceData});

  final BalanceData balanceData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Income',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF555555),
            ),
          ),
          Text(
            '${balanceData.income.toStringAsFixed(2)} SGD',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SpendingContainer extends StatelessWidget {
  const SpendingContainer({super.key, required this.balanceData});

  final BalanceData balanceData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          SpendingTotal(balanceData: balanceData),
          SpendingDetails(balanceData: balanceData),
        ],
      ),
    );
  }
}

class TotalBalanceContainer extends StatelessWidget {
  const TotalBalanceContainer({super.key, required this.balanceData});

  final BalanceData balanceData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Balance:',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF555555),
            ),
          ),
          Text(
            '${(balanceData.income - (balanceData.card + balanceData.transfer + balanceData.other)).toStringAsFixed(2)} SGD',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00C864), // Green color
            ),
          ),
        ],
      ),
    );
  }
}

class SpendingTotal extends StatelessWidget {
  const SpendingTotal({super.key, required this.balanceData});

  final BalanceData balanceData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Spending',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF555555),
            ),
          ),
          Text(
            '${(balanceData.card + balanceData.transfer + balanceData.other).toStringAsFixed(2)} SGD',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SpendingDetails extends StatelessWidget {
  const SpendingDetails({super.key, required this.balanceData});

  final BalanceData balanceData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 2,
              color: Color(0xFFE5E5E5),
              margin: EdgeInsets.only(right: 12),
            ),
            Expanded(
              child: Column(
                children: [
                  CardSpending(balanceData: balanceData),
                  TransferSpending(balanceData: balanceData),
                  OtherSpending(balanceData: balanceData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OtherSpending extends StatelessWidget {
  const OtherSpending({super.key, required this.balanceData});

  final BalanceData balanceData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Others:',
            style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
          ),
          Text(
            '${balanceData.other.toStringAsFixed(2)} SGD',
            style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
}

class TransferSpending extends StatelessWidget {
  const TransferSpending({super.key, required this.balanceData});

  final BalanceData balanceData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Transfer:',
            style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
          ),
          Text(
            '${balanceData.transfer.toStringAsFixed(2)} SGD',
            style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
}

class CardSpending extends StatelessWidget {
  const CardSpending({super.key, required this.balanceData});

  final BalanceData balanceData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Debit + Credit card:',
            style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
          ),
          Text(
            '${balanceData.card.toStringAsFixed(2)} SGD',
            style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
}
