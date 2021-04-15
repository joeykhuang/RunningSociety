import 'package:gotrue/gotrue.dart';
import 'package:supabase/supabase.dart';

const persistSessionKey = 'PERSIST_SESSION_KEY';

const supaBaseUrl = 'https://urkffiyklpgmgbueshrv.supabase.co';
const supaBaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYxNzQ1MzYzNCwiZXhwIjoxOTMzMDI5NjM0fQ.Y9_zQOGrJ4IvPBy2YbRNBgDRwvxp68YW82ADS1fPv8Y';

final gotrueClient = GoTrueClient(url: '$supaBaseUrl/auth/v1', headers: {
  'Authorization': 'Bearer $supaBaseAnonKey',
  'apikey': supaBaseAnonKey,
});

final client = SupabaseClient(supaBaseUrl, supaBaseAnonKey);
