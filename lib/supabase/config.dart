import 'package:gotrue/gotrue.dart';

const String SIGNIN_SCREEN = 'SIGNIN_SCREEN';
const String SIGNUP_SCREEN = 'SIGNUP_SCREEN';
const String PASSWORDRECOVER_SCREEN = 'PASSWORDRECOVER_SCREEN';

const PERSIST_SESSION_KEY = 'PERSIST_SESSION_KEY';

const SUPABASE_URL = 'https://urkffiyklpgmgbueshrv.supabase.co';
const SUPABASE_ANNON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYxNzQ1MzYzNCwiZXhwIjoxOTMzMDI5NjM0fQ.Y9_zQOGrJ4IvPBy2YbRNBgDRwvxp68YW82ADS1fPv8Y';
final gotrueClient = GoTrueClient(url: '$SUPABASE_URL/auth/v1', headers: {
  'Authorization': 'Bearer $SUPABASE_ANNON_KEY',
  'apikey': SUPABASE_ANNON_KEY,
});