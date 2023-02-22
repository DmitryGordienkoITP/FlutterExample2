// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:tariff_dv/core/services/auth_service.dart' as _i5;
import 'package:tariff_dv/core/services/delivery_service.dart' as _i12;
import 'package:tariff_dv/core/services/factory_service.dart' as _i8;
import 'package:tariff_dv/core/services/preferences_service.dart' as _i14;
import 'package:tariff_dv/core/services/product_service.dart' as _i10;
import 'package:tariff_dv/core/services/station_service.dart' as _i16;
import 'package:tariff_dv/data/data_providers/api/auth_api_provider.dart'
    as _i3;
import 'package:tariff_dv/data/data_providers/api/delivery_api_provider.dart'
    as _i6;
import 'package:tariff_dv/data/data_providers/api/factory_api_provider.dart'
    as _i7;
import 'package:tariff_dv/data/data_providers/api/product_api_provider.dart'
    as _i9;
import 'package:tariff_dv/data/data_providers/api/station_api_provider.dart'
    as _i15;
import 'package:tariff_dv/data/data_providers/preferences/preferences_provider.dart'
    as _i13;
import 'package:tariff_dv/data/data_providers/secure_storage/secure_storage_provider.dart'
    as _i4;
import 'package:tariff_dv/data/data_providers/signals/signalr_provider.dart'
    as _i11;

/// initializes the registration of auth-scope dependencies inside of [GetIt]
_i1.GetIt initAuthScope(
  _i1.GetIt getIt, {
  _i1.ScopeDisposeFunc? dispose,
}) {
  return _i2.GetItHelper(getIt).initScope(
    'auth',
    dispose: dispose,
    init: (_i2.GetItHelper gh) {
      gh.factory<_i3.AuthAPIProvider>(() => _i3.AuthAPIProvider());
      gh.factory<_i4.SecureStorageProvider>(() => _i4.SecureStorageProvider());
      gh.singleton<_i5.AuthService>(_i5.AuthService(
        gh<_i3.AuthAPIProvider>(),
        gh<_i4.SecureStorageProvider>(),
      ));
    },
  );
}

/// initializes the registration of fullAccess-scope dependencies inside of [GetIt]
_i1.GetIt initFullAccessScope(
  _i1.GetIt getIt, {
  _i1.ScopeDisposeFunc? dispose,
}) {
  return _i2.GetItHelper(getIt).initScope(
    'fullAccess',
    dispose: dispose,
    init: (_i2.GetItHelper gh) {
      gh.factory<_i6.DeliveryAPIProvider>(() => _i6.DeliveryAPIProvider());
      gh.factory<_i7.FactoryAPIProvider>(() => _i7.FactoryAPIProvider());
      gh.singleton<_i8.FactoryService>(
          _i8.FactoryService(gh<_i7.FactoryAPIProvider>()));
      gh.factory<_i9.ProductAPIProvider>(() => _i9.ProductAPIProvider());
      gh.singleton<_i10.ProductService>(
          _i10.ProductService(gh<_i9.ProductAPIProvider>()));
      gh.singleton<_i11.SignalRProvider>(
        _i11.SignalRProvider(gh<_i5.AuthService>())..postConstructInit(),
        dispose: (i) => i.dispose(),
      );
      gh.singleton<_i12.DeliveryService>(_i12.DeliveryService(
        gh<_i6.DeliveryAPIProvider>(),
        gh<_i11.SignalRProvider>(),
      ));
    },
  );
}

/// initializes the registration of baseAccess-scope dependencies inside of [GetIt]
_i1.GetIt initBaseAccessScope(
  _i1.GetIt getIt, {
  _i1.ScopeDisposeFunc? dispose,
}) {
  return _i2.GetItHelper(getIt).initScope(
    'baseAccess',
    dispose: dispose,
    init: (_i2.GetItHelper gh) {
      gh.singleton<_i13.PreferencesProvider>(_i13.PreferencesProvider());
      gh.singleton<_i14.PreferencesService>(
          _i14.PreferencesService(gh<_i13.PreferencesProvider>()));
      gh.factory<_i15.StationAPIProvider>(() => _i15.StationAPIProvider());
      gh.singleton<_i16.StationService>(
          _i16.StationService(gh<_i15.StationAPIProvider>()));
    },
  );
}
