// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solve_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$solveRepositoryHash() => r'77a9c5b1fd2554a7f7a38cbc07dd1667707fa47d';

/// See also [solveRepository].
@ProviderFor(solveRepository)
final solveRepositoryProvider = AutoDisposeProvider<SolveRepository>.internal(
  solveRepository,
  name: r'solveRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$solveRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SolveRepositoryRef = AutoDisposeProviderRef<SolveRepository>;
String _$solvesHash() => r'119c2db57af188a06671e84ca363db43955ca368';

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

/// See also [solves].
@ProviderFor(solves)
const solvesProvider = SolvesFamily();

/// See also [solves].
class SolvesFamily extends Family<List<Solve>> {
  /// See also [solves].
  const SolvesFamily();

  /// See also [solves].
  SolvesProvider call({
    CubeType? cubeType,
    String? sessionId,
  }) {
    return SolvesProvider(
      cubeType: cubeType,
      sessionId: sessionId,
    );
  }

  @override
  SolvesProvider getProviderOverride(
    covariant SolvesProvider provider,
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
  String? get name => r'solvesProvider';
}

/// See also [solves].
class SolvesProvider extends AutoDisposeProvider<List<Solve>> {
  /// See also [solves].
  SolvesProvider({
    CubeType? cubeType,
    String? sessionId,
  }) : this._internal(
          (ref) => solves(
            ref as SolvesRef,
            cubeType: cubeType,
            sessionId: sessionId,
          ),
          from: solvesProvider,
          name: r'solvesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$solvesHash,
          dependencies: SolvesFamily._dependencies,
          allTransitiveDependencies: SolvesFamily._allTransitiveDependencies,
          cubeType: cubeType,
          sessionId: sessionId,
        );

  SolvesProvider._internal(
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
    List<Solve> Function(SolvesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SolvesProvider._internal(
        (ref) => create(ref as SolvesRef),
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
  AutoDisposeProviderElement<List<Solve>> createElement() {
    return _SolvesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SolvesProvider &&
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

mixin SolvesRef on AutoDisposeProviderRef<List<Solve>> {
  /// The parameter `cubeType` of this provider.
  CubeType? get cubeType;

  /// The parameter `sessionId` of this provider.
  String? get sessionId;
}

class _SolvesProviderElement extends AutoDisposeProviderElement<List<Solve>>
    with SolvesRef {
  _SolvesProviderElement(super.provider);

  @override
  CubeType? get cubeType => (origin as SolvesProvider).cubeType;
  @override
  String? get sessionId => (origin as SolvesProvider).sessionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
