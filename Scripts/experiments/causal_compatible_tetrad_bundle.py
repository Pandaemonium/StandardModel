"""Stage A19 compatibility-selected conditional tetrad-bundle audit.

Stage A18 selected independently passing local patches primarily by overlap,
which left two of three held-out triples metrically incompatible.  This
successor freezes the A18 radius and splits every candidate overlap three ways:
60 percent fits an affine transition, 20 percent supplies an intrinsic
compatibility-selector error, and 20 percent remains untouched until after the
patch triple is selected.

Triple selection may use only local A17 gates, overlap counts, selector-slice
affine error, metric covariance, Lorentz defect, and affine/Lorentz cocycles.
Known coordinates are post-selection controls.  Approximate transition
cocycles still do not define an exact central Z2 spin obstruction class.
"""

from __future__ import annotations

import argparse
import itertools
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_frame_constrained_metric import MINKOWSKI_METRIC
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_johnston_probe_metric import (
    causal_interval_points,
    intrinsic_time_and_radius_from_relation,
    johnston_lightcone_embedding_from_intrinsic_data,
    minkowski_interval_coefficient,
)
from causal_operator_metric import finite_statistics, matrix_relative_error
from causal_tetrad_bundle_atlas import (
    LocalFittedPatch,
    TransitionAudit,
    build_local_patch,
    homogeneous_affine_matrix,
    oracle_patch_affine_map,
    orient_coframe_transitions,
    patch_domain,
    stable_center_candidates,
)
from causal_well_conditioning_audit import choose_deep_intrinsic_pivot


@dataclass(frozen=True)
class ThreeWayTransition:
    source_patch: int
    target_patch: int
    overlap_count: int
    fit_count: int
    selector_count: int
    test_count: int
    affine_map: np.ndarray
    selector_affine_relative_error: float
    test_affine_relative_error: float
    affine_design_condition: float
    metric_covariance_relative_error: float
    lorentz_defect_relative_error: float
    internal_transition: np.ndarray
    oracle_affine_map_relative_error: float
    fit_event_indices: np.ndarray | None = None
    selector_event_indices: np.ndarray | None = None
    test_event_indices: np.ndarray | None = None


@dataclass(frozen=True)
class CompatibleBundleSample:
    constructed_patch_count: int
    intrinsic_patch_gate_count: int
    selected_pivot_indices: list[int]
    selected_domain_counts: list[int]
    selected_core_counts: list[int]
    minimum_pair_overlap: int
    triple_overlap_count: int
    maximum_selector_affine_error: float | None
    maximum_test_affine_error: float | None
    maximum_affine_design_condition: float | None
    maximum_metric_covariance_error: float | None
    maximum_lorentz_defect: float | None
    affine_cocycle_relative_error: float | None
    lorentz_cocycle_relative_error: float | None
    orientation_time_orientation_gauge_exists: bool
    maximum_oracle_affine_map_error: float | None
    maximum_selected_patch_oracle_coordinate_error: float | None
    maximum_selected_patch_oracle_metric_error: float | None
    passes_selector_compatibility_gate: bool
    passes_heldout_transition_gate: bool
    passes_metric_bundle_gate: bool
    passes_spin_prerequisite_gate: bool
    exact_spin_obstruction_class_computed: bool


@dataclass(frozen=True)
class TripleAudit:
    indices: tuple[int, int, int]
    domains: list[np.ndarray]
    transitions: dict[tuple[int, int], ThreeWayTransition]
    minimum_pair_overlap: int
    triple_overlap_count: int
    maximum_selector_affine_error: float
    maximum_test_affine_error: float
    maximum_design_condition: float
    maximum_metric_error: float
    maximum_lorentz_defect: float
    affine_cocycle_error: float
    lorentz_cocycle_error: float
    orientation_exists: bool
    selector_gate: bool


def _relative_prediction_error(predicted: np.ndarray, expected: np.ndarray) -> float:
    denominator = max(
        float(np.linalg.norm(expected - np.mean(expected, axis=0))),
        1.0e-12,
    )
    return float(np.linalg.norm(predicted - expected) / denominator)


def fit_three_way_transition(
    rng: np.random.Generator,
    source_index: int,
    target_index: int,
    source: LocalFittedPatch,
    target: LocalFittedPatch,
    source_domain: np.ndarray,
    target_domain: np.ndarray,
    points: np.ndarray,
    fit_fraction: float,
    selector_fraction: float,
) -> ThreeWayTransition:
    """Fit, select, and finally test on disjoint overlap events."""

    if fit_fraction <= 0.0 or selector_fraction <= 0.0:
        raise ValueError("fit and selector fractions must be positive")
    if fit_fraction + selector_fraction >= 1.0:
        raise ValueError("three-way split must leave a positive test fraction")
    overlap = np.intersect1d(source_domain, target_domain)
    if len(overlap) < 15:
        raise ValueError("overlap is too small for a three-way affine split")
    order = rng.permutation(len(overlap))
    fit_count = max(5, int(np.floor(fit_fraction * len(order))))
    selector_count = max(1, int(np.floor(selector_fraction * len(order))))
    if fit_count + selector_count >= len(order):
        selector_count = len(order) - fit_count - 1
    fit_positions = order[:fit_count]
    selector_positions = order[fit_count : fit_count + selector_count]
    test_positions = order[fit_count + selector_count :]
    design = np.column_stack(
        (
            source.consensus_coordinates[overlap[fit_positions]],
            np.ones(len(fit_positions)),
        )
    )
    if np.linalg.matrix_rank(design) < 5:
        raise ValueError("overlap fit slice is not affinely full rank")
    coefficients = np.linalg.lstsq(
        design,
        target.consensus_coordinates[overlap[fit_positions]],
        rcond=None,
    )[0]

    def score(positions: np.ndarray) -> float:
        prediction = (
            np.column_stack(
                (
                    source.consensus_coordinates[overlap[positions]],
                    np.ones(len(positions)),
                )
            )
            @ coefficients
        )
        expected = target.consensus_coordinates[overlap[positions]]
        return _relative_prediction_error(prediction, expected)

    linear = coefficients[:4]
    metric_error = matrix_relative_error(
        linear @ target.metric @ linear.T, source.metric
    )
    internal = np.linalg.solve(source.coframe, linear @ target.coframe)
    lorentz_error = matrix_relative_error(
        internal @ MINKOWSKI_METRIC @ internal.T,
        MINKOWSKI_METRIC,
    )
    source_oracle = oracle_patch_affine_map(source, points)
    target_oracle = oracle_patch_affine_map(target, points)
    target_inverse = np.linalg.inv(target_oracle[:4])
    oracle = np.empty((5, 4), dtype=float)
    oracle[:4] = source_oracle[:4] @ target_inverse
    oracle[4] = (source_oracle[4] - target_oracle[4]) @ target_inverse
    return ThreeWayTransition(
        source_patch=source_index,
        target_patch=target_index,
        overlap_count=len(overlap),
        fit_count=len(fit_positions),
        selector_count=len(selector_positions),
        test_count=len(test_positions),
        affine_map=homogeneous_affine_matrix(coefficients),
        selector_affine_relative_error=score(selector_positions),
        test_affine_relative_error=score(test_positions),
        affine_design_condition=float(np.linalg.cond(design)),
        metric_covariance_relative_error=metric_error,
        lorentz_defect_relative_error=lorentz_error,
        internal_transition=internal,
        oracle_affine_map_relative_error=matrix_relative_error(coefficients, oracle),
        fit_event_indices=overlap[fit_positions],
        selector_event_indices=overlap[selector_positions],
        test_event_indices=overlap[test_positions],
    )


def _as_orientation_transitions(
    transitions: dict[tuple[int, int], ThreeWayTransition],
) -> dict[tuple[int, int], TransitionAudit]:
    """Expose the internal matrices to the A18 sign-gauge audit."""

    return {
        key: TransitionAudit(
            source_patch=value.source_patch,
            target_patch=value.target_patch,
            overlap_count=value.overlap_count,
            training_count=value.fit_count,
            heldout_count=value.test_count,
            affine_map=value.affine_map,
            affine_heldout_relative_error=value.test_affine_relative_error,
            affine_design_condition=value.affine_design_condition,
            metric_covariance_relative_error=(value.metric_covariance_relative_error),
            lorentz_defect_relative_error=value.lorentz_defect_relative_error,
            internal_transition=value.internal_transition,
            oracle_affine_map_relative_error=(value.oracle_affine_map_relative_error),
        )
        for key, value in transitions.items()
    }


def audit_triple(
    indices: tuple[int, int, int],
    domains: list[np.ndarray],
    pair_transitions: dict[tuple[int, int], ThreeWayTransition],
    minimum_pair_overlap: int,
    minimum_triple_overlap: int,
    maximum_selector_transition_error: float,
    maximum_transition_design_condition: float,
    maximum_metric_covariance_error: float,
    maximum_lorentz_defect: float,
    maximum_cocycle_error: float,
) -> TripleAudit:
    """Assemble pairwise transition data into one selector-side triple audit."""

    pairs = (
        (indices[0], indices[1]),
        (indices[0], indices[2]),
        (indices[1], indices[2]),
    )
    transitions = {
        (0, 1): pair_transitions[pairs[0]],
        (0, 2): pair_transitions[pairs[1]],
        (1, 2): pair_transitions[pairs[2]],
    }
    pair_overlap = [item.overlap_count for item in transitions.values()]
    triple_overlap = len(
        set(domains[indices[0]]) & set(domains[indices[1]]) & set(domains[indices[2]])
    )
    affine_cocycle = matrix_relative_error(
        transitions[(0, 1)].affine_map @ transitions[(1, 2)].affine_map,
        transitions[(0, 2)].affine_map,
    )
    lorentz_cocycle = matrix_relative_error(
        transitions[(0, 1)].internal_transition
        @ transitions[(1, 2)].internal_transition,
        transitions[(0, 2)].internal_transition,
    )
    selector_error = max(
        item.selector_affine_relative_error for item in transitions.values()
    )
    test_error = max(item.test_affine_relative_error for item in transitions.values())
    design_condition = max(
        item.affine_design_condition for item in transitions.values()
    )
    metric_error = max(
        item.metric_covariance_relative_error for item in transitions.values()
    )
    lorentz_error = max(
        item.lorentz_defect_relative_error for item in transitions.values()
    )
    orientation, _, _, _ = orient_coframe_transitions(
        _as_orientation_transitions(transitions)
    )
    selector_gate = bool(
        min(pair_overlap) >= minimum_pair_overlap
        and triple_overlap >= minimum_triple_overlap
        and selector_error <= maximum_selector_transition_error
        and design_condition <= maximum_transition_design_condition
        and metric_error <= maximum_metric_covariance_error
        and lorentz_error <= maximum_lorentz_defect
        and affine_cocycle <= maximum_cocycle_error
        and lorentz_cocycle <= maximum_cocycle_error
        and orientation
    )
    return TripleAudit(
        indices=indices,
        domains=[domains[index] for index in indices],
        transitions=transitions,
        minimum_pair_overlap=min(pair_overlap),
        triple_overlap_count=triple_overlap,
        maximum_selector_affine_error=selector_error,
        maximum_test_affine_error=test_error,
        maximum_design_condition=design_condition,
        maximum_metric_error=metric_error,
        maximum_lorentz_defect=lorentz_error,
        affine_cocycle_error=affine_cocycle,
        lorentz_cocycle_error=lorentz_cocycle,
        orientation_exists=orientation,
        selector_gate=selector_gate,
    )


def select_compatible_triple(audits: list[TripleAudit]) -> TripleAudit:
    """Select compatibility gates and residuals before untouched test error."""

    if not audits:
        raise ValueError("at least one triple audit is required")

    def score(audit: TripleAudit) -> tuple[object, ...]:
        return (
            -int(audit.selector_gate),
            audit.maximum_metric_error,
            audit.maximum_lorentz_defect,
            audit.maximum_selector_affine_error,
            max(audit.affine_cocycle_error, audit.lorentz_cocycle_error),
            -audit.triple_overlap_count,
            audit.indices,
        )

    return min(audits, key=score)


def unavailable_bundle_sample(
    constructed_patch_count: int,
    intrinsic_patch_gate_count: int,
) -> CompatibleBundleSample:
    """Record a failed realization without fabricating transition metrics."""

    return CompatibleBundleSample(
        constructed_patch_count=constructed_patch_count,
        intrinsic_patch_gate_count=intrinsic_patch_gate_count,
        selected_pivot_indices=[],
        selected_domain_counts=[],
        selected_core_counts=[],
        minimum_pair_overlap=0,
        triple_overlap_count=0,
        maximum_selector_affine_error=None,
        maximum_test_affine_error=None,
        maximum_affine_design_condition=None,
        maximum_metric_covariance_error=None,
        maximum_lorentz_defect=None,
        affine_cocycle_relative_error=None,
        lorentz_cocycle_relative_error=None,
        orientation_time_orientation_gauge_exists=False,
        maximum_oracle_affine_map_error=None,
        maximum_selected_patch_oracle_coordinate_error=None,
        maximum_selected_patch_oracle_metric_error=None,
        passes_selector_compatibility_gate=False,
        passes_heldout_transition_gate=False,
        passes_metric_bundle_gate=False,
        passes_spin_prerequisite_gate=False,
        exact_spin_obstruction_class_computed=False,
    )


def reconstruct_realization(
    rng: np.random.Generator,
    args: argparse.Namespace,
) -> CompatibleBundleSample:
    """Construct candidate patches, select compatibility, then open test data."""

    points, bottom_index, top_index = causal_interval_points(
        rng, args.events, args.duration
    )
    relation = causal_relation_matrix(points, args.block_size)
    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    intrinsic_time, intrinsic_radius = intrinsic_time_and_radius_from_relation(
        relation,
        density,
        args.dimension,
        bottom_index,
        top_index,
        args.duration,
    )
    root_pivot = choose_deep_intrinsic_pivot(
        relation,
        intrinsic_time,
        intrinsic_radius,
        args.duration,
        args.minimum_lightcone_count,
    )
    root = johnston_lightcone_embedding_from_intrinsic_data(
        relation,
        density,
        args.dimension,
        bottom_index,
        top_index,
        root_pivot,
        intrinsic_time,
        intrinsic_radius,
        spatial_rank=args.dimension - 1,
    )
    candidates = stable_center_candidates(
        relation,
        root,
        args.minimum_lightcone_count,
        args.maximum_center_candidates,
    )
    center_distance = np.linalg.norm(root.probes, axis=1)
    patch_seeds = rng.integers(0, 2**63 - 1, size=len(candidates))
    patches: list[LocalFittedPatch] = []
    for candidate, seed in zip(candidates, patch_seeds, strict=True):
        try:
            patch = build_local_patch(
                np.random.default_rng(int(seed)),
                relation,
                points,
                density,
                args.dimension,
                bottom_index,
                top_index,
                intrinsic_time,
                intrinsic_radius,
                int(candidate),
                float(center_distance[candidate]),
                args.scaffold_scale,
                args.anchor_time_multiplier,
                args.active_count,
                args.relative_time_shell_width,
                args.maximum_lower_candidates,
                args.maximum_upper_candidates,
                args.metric_regularization,
                args.local_heldout_fraction,
                args.minimum_heldout_open_count,
                args.maximum_noncausal_pairs,
                args.minimum_evaluation_count,
                args.maximum_chart_consistency_error,
                args.maximum_interval_error,
                args.minimum_heldout_causal_sign_fraction,
                args.maximum_noncausal_violation_fraction,
                args.minimum_causal_sensitivity,
                args.minimum_causal_specificity,
            )
            patches.append(patch)
        except (ArithmeticError, KeyError, np.linalg.LinAlgError, ValueError):
            continue
    eligible = [patch for patch in patches if patch.passes_intrinsic_patch_gate]
    if len(eligible) < 3:
        return unavailable_bundle_sample(len(patches), len(eligible))
    domains = [patch_domain(patch, args.patch_radius) for patch in eligible]
    pair_transitions: dict[tuple[int, int], ThreeWayTransition] = {}
    pair_seeds = rng.integers(
        0, 2**63 - 1, size=len(eligible) * (len(eligible) - 1) // 2
    )
    for pair_index, (left, right) in enumerate(
        itertools.combinations(range(len(eligible)), 2)
    ):
        if len(np.intersect1d(domains[left], domains[right])) < (
            args.minimum_pair_overlap
        ):
            continue
        try:
            pair_transitions[(left, right)] = fit_three_way_transition(
                np.random.default_rng(int(pair_seeds[pair_index])),
                left,
                right,
                eligible[left],
                eligible[right],
                domains[left],
                domains[right],
                points,
                args.transition_fit_fraction,
                args.transition_selector_fraction,
            )
        except (np.linalg.LinAlgError, ValueError):
            continue
    audits: list[TripleAudit] = []
    for indices in itertools.combinations(range(len(eligible)), 3):
        required = (
            (indices[0], indices[1]),
            (indices[0], indices[2]),
            (indices[1], indices[2]),
        )
        if not all(pair in pair_transitions for pair in required):
            continue
        audit = audit_triple(
            indices,
            domains,
            pair_transitions,
            args.minimum_pair_overlap,
            args.minimum_triple_overlap,
            args.maximum_selector_transition_error,
            args.maximum_transition_design_condition,
            args.maximum_metric_covariance_error,
            args.maximum_lorentz_defect,
            args.maximum_cocycle_error,
        )
        if audit.triple_overlap_count >= args.minimum_triple_overlap:
            audits.append(audit)
    if not audits:
        return unavailable_bundle_sample(len(patches), len(eligible))
    selected = select_compatible_triple(audits)
    selected_patches = [eligible[index] for index in selected.indices]
    heldout_transition = bool(
        selected.selector_gate
        and selected.maximum_test_affine_error <= args.maximum_test_transition_error
    )
    metric_bundle = bool(
        heldout_transition
        and selected.maximum_metric_error <= args.maximum_metric_covariance_error
        and selected.maximum_lorentz_defect <= args.maximum_lorentz_defect
    )
    spin_prerequisite = bool(metric_bundle and selected.orientation_exists)
    return CompatibleBundleSample(
        constructed_patch_count=len(patches),
        intrinsic_patch_gate_count=len(eligible),
        selected_pivot_indices=[patch.pivot_index for patch in selected_patches],
        selected_domain_counts=[len(domain) for domain in selected.domains],
        selected_core_counts=[len(patch.carrier_indices) for patch in selected_patches],
        minimum_pair_overlap=selected.minimum_pair_overlap,
        triple_overlap_count=selected.triple_overlap_count,
        maximum_selector_affine_error=(selected.maximum_selector_affine_error),
        maximum_test_affine_error=selected.maximum_test_affine_error,
        maximum_affine_design_condition=selected.maximum_design_condition,
        maximum_metric_covariance_error=selected.maximum_metric_error,
        maximum_lorentz_defect=selected.maximum_lorentz_defect,
        affine_cocycle_relative_error=selected.affine_cocycle_error,
        lorentz_cocycle_relative_error=selected.lorentz_cocycle_error,
        orientation_time_orientation_gauge_exists=(selected.orientation_exists),
        maximum_oracle_affine_map_error=max(
            transition.oracle_affine_map_relative_error
            for transition in selected.transitions.values()
        ),
        maximum_selected_patch_oracle_coordinate_error=max(
            patch.oracle_coordinate_error for patch in selected_patches
        ),
        maximum_selected_patch_oracle_metric_error=max(
            patch.oracle_metric_error for patch in selected_patches
        ),
        passes_selector_compatibility_gate=selected.selector_gate,
        passes_heldout_transition_gate=heldout_transition,
        passes_metric_bundle_gate=metric_bundle,
        passes_spin_prerequisite_gate=spin_prerequisite,
        exact_spin_obstruction_class_computed=False,
    )


def summarize_samples(samples: list[CompatibleBundleSample]) -> dict[str, object]:
    """Aggregate compatibility-selected bundle controls."""

    def statistics(attribute: str) -> dict[str, float | int | None]:
        return finite_statistics([getattr(sample, attribute) for sample in samples])

    def rate(attribute: str) -> float:
        return sum(bool(getattr(sample, attribute)) for sample in samples) / len(
            samples
        )

    return {
        "samples": len(samples),
        "constructed_patch_count": statistics("constructed_patch_count"),
        "intrinsic_patch_gate_count": statistics("intrinsic_patch_gate_count"),
        "minimum_pair_overlap": statistics("minimum_pair_overlap"),
        "triple_overlap_count": statistics("triple_overlap_count"),
        "maximum_selector_affine_error": statistics("maximum_selector_affine_error"),
        "maximum_test_affine_error": statistics("maximum_test_affine_error"),
        "maximum_affine_design_condition": statistics(
            "maximum_affine_design_condition"
        ),
        "maximum_metric_covariance_error": statistics(
            "maximum_metric_covariance_error"
        ),
        "maximum_lorentz_defect": statistics("maximum_lorentz_defect"),
        "affine_cocycle_relative_error": statistics("affine_cocycle_relative_error"),
        "lorentz_cocycle_relative_error": statistics("lorentz_cocycle_relative_error"),
        "maximum_oracle_affine_map_error": statistics(
            "maximum_oracle_affine_map_error"
        ),
        "maximum_selected_patch_oracle_coordinate_error": statistics(
            "maximum_selected_patch_oracle_coordinate_error"
        ),
        "maximum_selected_patch_oracle_metric_error": statistics(
            "maximum_selected_patch_oracle_metric_error"
        ),
        "orientation_time_orientation_success_rate": rate(
            "orientation_time_orientation_gauge_exists"
        ),
        "selector_compatibility_gate_success_rate": rate(
            "passes_selector_compatibility_gate"
        ),
        "heldout_transition_gate_success_rate": rate("passes_heldout_transition_gate"),
        "metric_bundle_gate_success_rate": rate("passes_metric_bundle_gate"),
        "spin_prerequisite_gate_success_rate": rate("passes_spin_prerequisite_gate"),
    }


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run a closed development or frozen held-out compatibility audit."""

    if args.dimension != 4 or args.realizations <= 0:
        raise ValueError("this benchmark requires positive 3+1 realizations")
    seed_sequence = np.random.SeedSequence(args.seed)
    samples = [
        reconstruct_realization(np.random.default_rng(child), args)
        for child in seed_sequence.spawn(args.realizations)
    ]
    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    result: dict[str, object] = {
        "status": f"closed {args.mode} compatibility-selected bundle audit",
        "construction_and_selection_use_known_embedding": False,
        "oracle_scores_use_known_embedding": True,
        "overlap_is_split_into_fit_selector_and_test_events": True,
        "local_metric_prior_uses_chart_transported_minkowski_forms": True,
        "exact_spin_obstruction_class_computed": False,
        "spin_prerequisite_only": True,
        "connection_and_curvature_scores_opened": False,
        "dimension_density_endpoints_and_scale_are_supplied": True,
        "settings": {
            "events_including_endpoints": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "density": density,
            "patch_radius": args.patch_radius,
            "maximum_center_candidates": args.maximum_center_candidates,
            "metric_regularization": args.metric_regularization,
            "transition_fit_fraction": args.transition_fit_fraction,
            "transition_selector_fraction": args.transition_selector_fraction,
            "minimum_pair_overlap": args.minimum_pair_overlap,
            "minimum_triple_overlap": args.minimum_triple_overlap,
            "maximum_selector_transition_error": (
                args.maximum_selector_transition_error
            ),
            "maximum_test_transition_error": args.maximum_test_transition_error,
            "maximum_transition_design_condition": (
                args.maximum_transition_design_condition
            ),
            "maximum_metric_covariance_error": (args.maximum_metric_covariance_error),
            "maximum_lorentz_defect": args.maximum_lorentz_defect,
            "maximum_cocycle_error": args.maximum_cocycle_error,
            "seed": args.seed,
        },
        "selection_rule": (
            "selector compatibility gate, then metric covariance, Lorentz "
            "defect, selector affine error, cocycle error, and triple overlap; "
            "test affine error is opened only after selection"
        ),
        "summary": summarize_samples(samples),
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--mode", choices=("development", "held-out"), default="development"
    )
    parser.add_argument("--events", type=int, default=4000)
    parser.add_argument("--realizations", type=int, default=5)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--dimension", type=int, default=4)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--scaffold-scale", type=float, default=0.05)
    parser.add_argument("--anchor-time-multiplier", type=float, default=8.0)
    parser.add_argument("--active-count", type=int, default=12)
    parser.add_argument("--minimum-lightcone-count", type=int, default=20)
    parser.add_argument("--maximum-center-candidates", type=int, default=12)
    parser.add_argument("--relative-time-shell-width", type=float, default=0.35)
    parser.add_argument("--maximum-lower-candidates", type=int, default=10)
    parser.add_argument("--maximum-upper-candidates", type=int, default=18)
    parser.add_argument("--metric-regularization", type=float, default=0.1)
    parser.add_argument("--local-heldout-fraction", type=float, default=0.20)
    parser.add_argument("--minimum-heldout-open-count", type=int, default=2)
    parser.add_argument("--maximum-noncausal-pairs", type=int, default=6000)
    parser.add_argument("--minimum-evaluation-count", type=int, default=24)
    parser.add_argument("--maximum-chart-consistency-error", type=float, default=0.85)
    parser.add_argument("--maximum-interval-error", type=float, default=0.20)
    parser.add_argument(
        "--minimum-heldout-causal-sign-fraction", type=float, default=0.95
    )
    parser.add_argument(
        "--maximum-noncausal-violation-fraction", type=float, default=0.10
    )
    parser.add_argument("--minimum-causal-sensitivity", type=float, default=0.80)
    parser.add_argument("--minimum-causal-specificity", type=float, default=0.95)
    parser.add_argument("--patch-radius", type=float, default=0.40)
    parser.add_argument("--transition-fit-fraction", type=float, default=0.60)
    parser.add_argument("--transition-selector-fraction", type=float, default=0.20)
    parser.add_argument("--minimum-pair-overlap", type=int, default=30)
    parser.add_argument("--minimum-triple-overlap", type=int, default=15)
    parser.add_argument("--maximum-selector-transition-error", type=float, default=0.25)
    parser.add_argument("--maximum-test-transition-error", type=float, default=0.25)
    parser.add_argument(
        "--maximum-transition-design-condition", type=float, default=50.0
    )
    parser.add_argument("--maximum-metric-covariance-error", type=float, default=0.35)
    parser.add_argument("--maximum-lorentz-defect", type=float, default=0.35)
    parser.add_argument("--maximum-cocycle-error", type=float, default=0.25)
    parser.add_argument("--seed", type=int, default=20260840)
    parser.add_argument("--include-samples", action="store_true")
    parser.add_argument("--output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    result = run_experiment(args)
    payload = json.dumps(result, indent=2, sort_keys=True)
    if args.output is None:
        print(payload)
    else:
        args.output.write_text(payload + "\n", encoding="utf-8", newline="\n")


if __name__ == "__main__":
    main()
