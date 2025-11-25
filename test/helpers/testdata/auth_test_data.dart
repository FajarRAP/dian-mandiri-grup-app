import 'package:ship_tracker/features/auth/data/models/sign_in_response_model.dart';
import 'package:ship_tracker/features/auth/data/models/token_model.dart';
import 'package:ship_tracker/features/auth/data/models/user_model.dart';
import 'package:ship_tracker/features/auth/domain/entities/user_entity.dart';
import 'package:ship_tracker/features/auth/domain/usecases/refresh_token_use_case.dart';
import 'package:ship_tracker/features/auth/domain/usecases/update_profile_use_case.dart';

const tUserEntity = UserEntity(
    id: 'db7d1edf-089d-4544-9ea3-ae15c44db7b5',
    name: 'Fajar',
    email: 'fajary363@gmail.com',
    permissions: ['super_admin']);

const tUserModel = UserModel(
    id: 'db7d1edf-089d-4544-9ea3-ae15c44db7b5',
    name: 'Fajar',
    email: 'fajary363@gmail.com',
    permissions: ['super_admin']);

const tUserString = '''
{
  "id": "db7d1edf-089d-4544-9ea3-ae15c44db7b5",
  "name": "Fajar",
  "email": "fajary363@gmail.com",
  "permissions": ["super_admin"]
}
''';

const tSignInResponseModel = SignInResponseModel(
    accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    refreshToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    message: 'Success verify login by google',
    user: UserModel(
        id: 'db7d1edf-089d-4544-9ea3-ae15c44db7b5',
        name: 'Fajar',
        email: 'fajary363@gmail.com',
        permissions: ['super_admin']));

const tTokenModel = TokenModel(
    accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    refreshToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    message: 'Auth refresh Successfully');

const tUpdateProfileParams = UpdateProfileUseCaseParams(name: 'name');
const tUpdateProfileSuccess = 'Profile updated successfully';

const tFetchUserSuccess = UserEntity(
    id: 'db7d1edf-089d-4544-9ea3-ae15c44db7b5',
    name: 'Fajar',
    email: 'fajary363@gmail.com',
    permissions: ['super_admin']);

const tSignOutSuccess = 'Auth logout successfully';

const tGoogleAccessToken = 'google_access_token';

const tRefreshTokenParams =
    RefreshTokenUseCaseParams(refreshToken: 'refreshToken');
const tRefreshTokenSuccess = TokenModel(
    accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    refreshToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    message: 'Auth refresh Successfully');

const tRefreshTokenNull = null;
const tRefreshTokenString = 'eyJhbGciOi';
