// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scramble_generator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scrambleGeneratorHash() => r'fe3b3780884ff2bed245ed26afaf0c7be573552f';

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

abstract class _$ScrambleGenerator extends BuildlessNotifier<ScrambleState> {
  late final CubeType cubeType;

  ScrambleState build(
    CubeType cubeType,
  );
}

/// See also [ScrambleGenerator].
@ProviderFor(ScrambleGenerator)
const scrambleGeneratorProvider = ScrambleGeneratorFamily();

/// See also [ScrambleGenerator].
class ScrambleGeneratorFamily extends Family<ScrambleState> {
  /// See also [ScrambleGenerator].
  const ScrambleGeneratorFamily();

  /// See also [ScrambleGenerator].
  ScrambleGeneratorProvider call(
    CubeType cubeType,
  ) {
    return ScrambleGeneratorProvider(
      cubeType,
    );
  }

  @override
  ScrambleGeneratorProvider getProviderOverride(
    covariant ScrambleGeneratorProvider provider,
  ) {
    return call(
      provider.cubeType,
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
  String? get name => r'scrambleGeneratorProvider';
}

/// See also [ScrambleGenerator].
class ScrambleGeneratorProvider
    extends NotifierProviderImpl<ScrambleGenerator, ScrambleState> {
  /// See also [ScrambleGenerator].
  ScrambleGeneratorProvider(
    CubeType cubeType,
  ) : this._internal(
          () => ScrambleGenerator()..cubeType = cubeType,
          from: scrambleGeneratorProvider,
          name: r'scrambleGeneratorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$scrambleGeneratorHash,
          dependencies: ScrambleGeneratorFamily._dependencies,
          allTransitiveDependencies:
              ScrambleGeneratorFamily._allTransitiveDependencies,
          cubeType: cubeType,
        );

  ScrambleGeneratorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cubeType,
  }) : super.internal();

  final CubeType cubeType;

  @override
  ScrambleState runNotifierBuild(
    covariant ScrambleGenerator notifier,
  ) {
    return notifier.build(
      cubeType,
    );
  }

  @override
  Override overrideWith(ScrambleGenerator Function() create) {
    return ProviderOverride(
      origin: this,
      override: ScrambleGeneratorProvider._internal(
        () => create()..cubeType = cubeType,
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
  NotifierProviderElement<ScrambleGenerator, ScrambleState> createElement() {
    return _ScrambleGeneratorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScrambleGeneratorProvider && other.cubeType == cubeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cubeType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ScrambleGeneratorRef on NotifierProviderRef<ScrambleState> {
  /// The parameter `cubeType` of this provider.
  CubeType get cubeType;
}

class _ScrambleGeneratorProviderElement
    extends NotifierProviderElement<ScrambleGenerator, ScrambleState>
    with ScrambleGeneratorRef {
  _ScrambleGeneratorProviderElement(super.provider);

  @override
  CubeType get cubeType => (origin as ScrambleGeneratorProvider).cubeType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
