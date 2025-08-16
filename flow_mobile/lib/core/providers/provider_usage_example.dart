import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/core/providers/providers.dart';
import 'package:flow_mobile/domain/entities/user.dart';

/// Example widget showing how to use Riverpod providers
/// This replaces the old GetIt service location pattern
class ProviderUsageExample extends ConsumerWidget {
  const ProviderUsageExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Provider Usage Example')),
      body: Column(
        children: [
          // Example 1: Using synchronous providers (services)
          _buildServiceExample(ref),
          
          // Example 2: Using async providers (repositories/use cases)
          _buildAsyncExample(ref),
          
          // Example 3: Using providers in business logic
          _buildBusinessLogicExample(ref),
        ],
      ),
    );
  }

  Widget _buildServiceExample(WidgetRef ref) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service Providers (Synchronous)', 
                 style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Direct access to services - these are synchronous
                final connectionService = ref.read(connectionServiceProvider);
                final authService = ref.read(authServiceProvider);
                final apiService = ref.read(apiServiceProvider);
                
                print('Services loaded: ${connectionService.runtimeType}, '
                      '${authService.runtimeType}, ${apiService.runtimeType}');
              },
              child: Text('Load Services'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAsyncExample(WidgetRef ref) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Async Providers (Repositories/Use Cases)', 
                 style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            
            // Example of watching an async provider
            Consumer(
              builder: (context, ref, child) {
                final userRepositoryAsync = ref.watch(userRepositoryProvider);
                
                return userRepositoryAsync.when(
                  data: (repository) => ElevatedButton(
                    onPressed: () async {
                      try {
                        final user = await repository.getUser();
                        print('User loaded: ${user.name}');
                      } catch (e) {
                        print('Error loading user: $e');
                      }
                    },
                    child: Text('Load User Repository'),
                  ),
                  loading: () => CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessLogicExample(WidgetRef ref) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Use Case Providers (Business Logic)', 
                 style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            
            // Example of using use case providers
            Consumer(
              builder: (context, ref, child) {
                final getUserUseCaseAsync = ref.watch(getUserUseCaseProvider);
                
                return getUserUseCaseAsync.when(
                  data: (useCase) => ElevatedButton(
                    onPressed: () async {
                      try {
                        final user = await useCase.execute();
                        print('User from use case: ${user.name}');
                      } catch (e) {
                        print('Error executing use case: $e');
                      }
                    },
                    child: Text('Execute Get User Use Case'),
                  ),
                  loading: () => CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Example of a more complex widget that uses multiple providers
class UserProfileWidget extends ConsumerStatefulWidget {
  const UserProfileWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends ConsumerState<UserProfileWidget> {
  User? _user;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Wait for the use case provider to be ready
      final getUserUseCase = await ref.read(getUserUseCaseProvider.future);
      
      // Execute the use case
      final user = await getUserUseCase.execute();
      
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUser(User updatedUser) async {
    try {
      // Get the update use case
      final updateUserUseCase = await ref.read(updateUserUseCaseProvider.future);
      
      // Execute the update
      await updateUserUseCase.execute(updatedUser);
      
      // Refresh the user data
      await _loadUser();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadUser,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_user == null) {
      return Center(child: Text('No user data'));
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Profile', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Name: ${_user!.name}'),
            Text('Email: ${_user!.email}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Example of updating user
                final updatedUser = _user!.copyWith(
                  name: '${_user!.name} (Updated)',
                );
                _updateUser(updatedUser);
              },
              child: Text('Update User'),
            ),
          ],
        ),
      ),
    );
  }
}