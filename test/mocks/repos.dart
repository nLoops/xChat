import 'package:mockito/mockito.dart';
import 'package:xchat/data/repos/auth_repo.dart';
import 'package:xchat/data/repos/storage_repo.dart';
import 'package:xchat/data/repos/user_repo.dart';

class AuthRepoMock extends Mock implements AuthenticationRepository{}

class UserRepoMock extends Mock implements UserDataRepository{}

class StorageRepoMock extends Mock implements StorageRepository{}

