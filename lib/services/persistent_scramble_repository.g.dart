// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persistent_scramble_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$persistentScrambleRepositoryHash() =>
    r'8ec0c42129a691c10f28841f4dcc585fc299798f';

/// See also [persistentScrambleRepository].
@ProviderFor(persistentScrambleRepository)
final persistentScrambleRepositoryProvider =
    AutoDisposeProvider<PersistentScrambleRepository>.internal(
  persistentScrambleRepository,
  name: r'persistentScrambleRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$persistentScrambleRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PersistentScrambleRepositoryRef
    = AutoDisposeProviderRef<PersistentScrambleRepository>;
String _$scrambleHistoryHash() => r'478ebefd5450d1656165f51347e4aa5b783bdcb1';

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

/// See also [scrambleHistory].
@ProviderFor(scrambleHistory)
const scrambleHistoryProvider = ScrambleHistoryFamily();

/// See also [scrambleHistory].
class ScrambleHistoryFamily extends Family<List<ScrambleHistoryItem>> {
  /// See also [scrambleHistory].
  const ScrambleHistoryFamily();

  /// See also [scrambleHistory].
  ScrambleHistoryProvider call({
    CubeType? cubeType,
  }) {
    return ScrambleHistoryProvider(
      cubeType: cubeType,
    );
  }

  @override
  ScrambleHistoryProvider getProviderOverride(
    covariant ScrambleHistoryProvider provider,
  ) {
    return call(
      cubeType: provider.cubeType,
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
  String? get name => r'scrambleHistoryProvider';
}

/// See also [scrambleHistory].
class ScrambleHistoryProvider
    extends AutoDisposeProvider<List<ScrambleHistoryItem>> {
  /// See also [scrambleHistory].
  ScrambleHistoryProvider({
    CubeType? cubeType,
  }) : this._internal(
          (ref) => scrambleHistory(
            ref as ScrambleHistoryRef,
            cubeType: cubeType,
          ),
          from: scrambleHistoryProvider,
          name: r'scrambleHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$scrambleHistoryHash,
          dependencies: ScrambleHistoryFamily._dependencies,
          allTransitiveDependencies:
              ScrambleHistoryFamily._allTransitiveDependencies,
          cubeType: cubeType,
        );

  ScrambleHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cubeType,
  }) : super.internal();

  final CubeType? cubeType;

  @override
  Override overrideWith(
    List<ScrambleHistoryItem> Function(ScrambleHistoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScrambleHistoryProvider._internal(
        (ref) => create(ref as ScrambleHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cubeType: cubeType,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<ScrambleHistoryItem>> createElement() {
    return _ScrambleHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScrambleHistoryProvider && other.cubeType == cubeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cubeType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ScrambleHistoryRef on AutoDisposeProviderRef<List<ScrambleHistoryItem>> {
  /// The parameter `cubeType` of this provider.
  CubeType? get cubeType;
}

class _ScrambleHistoryProviderElement
    extends AutoDisposeProviderElement<List<ScrambleHistoryItem>>
    with ScrambleHistoryRef {
  _ScrambleHistoryProviderElement(super.provider);

  @override
  CubeType? get cubeType => (origin as ScrambleHistoryProvider).cubeType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
