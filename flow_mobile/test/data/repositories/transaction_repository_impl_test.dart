import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/data/repositories/transaction_repository_impl.dart';
import 'package:flow_mobile/data/datasources/local/transaction_local_datasource.dart';
import 'package:flow_mobile/data/datasources/remote/transaction_remote_datasource.dart';

import 'transaction_repository_impl_test.mocks.dart';

@GenerateMocks([TransactionLocalDataSource, TransactionRemoteDataSource])
void main() {
  late TransactionRepositoryImpl repository;
  late MockTransactionLocalDataSource mockLocalDataSource;
  late MockTransactionRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockTransactionLocalDataSource();
    mockRemoteDataSource = MockTransactionRemoteDataSource();
    repository = TransactionRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('TransactionRepositoryImpl', () {
    final testDate = DateTime(2024, 1, 1);
    final testTransaction = Transaction(
      id: '1',
      amount: 100.0,
      description: 'Test transaction',
      date: testDate,
      category: 'Food',
      type: TransactionType.expense,
    );

    group('getTransactions', () {
      test('should return transactions from local data source', () async {
        // Arrange
        final expectedTransactions = [testTransaction];
        when(mockLocalDataSource.getTransactions(any))
            .thenAnswer((_) async => expectedTransactions);

        // Act
        final result = await repository.getTransactions(testDate);

        // Assert
        expect(result, equals(expectedTransactions));
        verify(mockLocalDataSource.getTransactions(testDate)).called(1);
      });

      test('should throw exception when local data source throws', () async {
        // Arrange
        when(mockLocalDataSource.getTransactions(any))
            .thenThrow(Exception('Local storage error'));

        // Act & Assert
        expect(
          () => repository.getTransactions(testDate),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getTransactionsFromTo', () {
      test('should return transactions from local data source for date range', () async {
        // Arrange
        final fromDate = DateTime(2024, 1, 1);
        final toDate = DateTime(2024, 1, 31);
        final expectedTransactions = [testTransaction];
        
        when(mockLocalDataSource.getTransactionsFromTo(any, any))
            .thenAnswer((_) async => expectedTransactions);

        // Act
        final result = await repository.getTransactionsFromTo(fromDate, toDate);

        // Assert
        expect(result, equals(expectedTransactions));
        verify(mockLocalDataSource.getTransactionsFromTo(fromDate, toDate)).called(1);
      });
    });

    group('addTransaction', () {
      test('should call local data source addTransaction', () async {
        // Arrange
        when(mockLocalDataSource.addTransaction(any))
            .thenAnswer((_) async => {});

        // Act
        await repository.addTransaction(testTransaction);

        // Assert
        verify(mockLocalDataSource.addTransaction(testTransaction)).called(1);
      });

      test('should throw exception when local data source throws', () async {
        // Arrange
        when(mockLocalDataSource.addTransaction(any))
            .thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(
          () => repository.addTransaction(testTransaction),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('clearTransactions', () {
      test('should call local data source clearTransactions', () async {
        // Arrange
        when(mockLocalDataSource.clearTransactions())
            .thenAnswer((_) async => {});

        // Act
        await repository.clearTransactions();

        // Assert
        verify(mockLocalDataSource.clearTransactions()).called(1);
      });
    });

    group('getAllTransactions', () {
      test('should return all transactions from local data source', () async {
        // Arrange
        final expectedTransactions = [testTransaction];
        when(mockLocalDataSource.getAllTransactions())
            .thenAnswer((_) async => expectedTransactions);

        // Act
        final result = await repository.getAllTransactions();

        // Assert
        expect(result, equals(expectedTransactions));
        verify(mockLocalDataSource.getAllTransactions()).called(1);
      });
    });
  });
}