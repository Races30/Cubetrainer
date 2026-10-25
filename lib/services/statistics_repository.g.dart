// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$statisticsRepositoryHash() =>
    r'ccb88f2cbafa63e3a4ba1e79fc3fdd3a5cf174ec';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [statisticsRepository].
@ProviderFor(statisticsRepository)
const statisticsRepositoryProvider = StatisticsRepositoryFamily();

/// See also [statisticsRepository].
class StatisticsRepositoryFamily extends Family<StatisticsRepository> {
  /// See also [statisticsRepository].
  const StatisticsRepositoryFamily();

  /// See also [statisticsRepository].
  StatisticsRepositoryProvider call({
    CubeType? cubeType,
    String? sessionId,
  }) {
    return StatisticsRepositoryProvider(
      cubeType: cubeType,
      sessionId: sessionId,
    );
  }

  @override
  StatisticsRepositoryProvider getProviderOverride(
    covariant StatisticsRepositoryProvider provider,
  ) {
    return call(
      cubeType: provider.cubeType,
      sessionId: provider.sessionId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'statisticsRepositoryProvider';
}

/// See also [statisticsRepository].
class StatisticsRepositoryProvider
    extends AutoDisposeProvider<StatisticsRepository> {
  /// See also [statisticsRepository].
  StatisticsRepositoryProvider({
    CubeType? cubeType,
    String? sessionId,
  }) : this._internal(
          (ref) => statisticsRepository(
            ref as StatisticsRepositoryRef,
            cubeType: cubeType,
            sessionId: sessionId,
          ),
          from: statisticsRepositoryProvider,
          name: r'statisticsRepositoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$statisticsRepositoryHash,
          dependencies: StatisticsRepositoryFamily._dependencies,
          allTransitiveDependencies:
              StatisticsRepositoryFamily._allTransitiveDependencies,
          cubeType: cubeType,
          sessionId: sessionId,
        );

  StatisticsRepositoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cubeType,
    required this.sessionId,
  }) : super.internal();

  final CubeType? cubeType;
  final String? sessionId;

  @override
  Override overrideWith(
    StatisticsRepository Function(StatisticsRepositoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StatisticsRepositoryProvider._internal(
        (ref) => create(ref as StatisticsRepositoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cubeType: cubeType,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<StatisticsRepository> createElement() {
    return _StatisticsRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StatisticsRepositoryProvider &&
        other.cubeType == cubeType &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cubeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StatisticsRepositoryRef on AutoDisposeProviderRef<StatisticsRepository> {
  /// The parameter `cubeType` of this provider.
  CubeType? get cubeType;

  /// The parameter `sessionId` of this provider.
  String? get sessionId;
}

class _StatisticsRepositoryProviderElement
    extends AutoDisposeProviderElement<StatisticsRepository>
    with StatisticsRepositoryRef {
  _StatisticsRepositoryProviderElement(super.provider);

  @override
  CubeType? get cubeType => (origin as StatisticsRepositoryProvider).cubeType;
  @override
  String? get sessionId => (origin as StatisticsRepositoryProvider).sessionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
