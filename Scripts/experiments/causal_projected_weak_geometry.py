"""Stage A40 projected weak Hessian, Gamma2, and Ricci audit.

This module keeps the A39 degree-two algebra envelope but changes the topology:
every operator and corrected-product-defect output is projected back to the
envelope before it is reused.  The resulting finite weak Hessian and Gamma2 are
evaluated on the complete maximal two-sided-depth orbit.

The flat controls are affine, temporal-quadratic, and shear-quadratic charts.
All have zero continuum Ricci curvature; the nonlinear charts have nonzero
Hessians.  This remains a conditional numerical audit with supplied dimension,
density, endpoints, rank, and causal-operator family.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_mesoscopic_algebra import (
    DIAGNOSTIC_NAMES,
    AlgebraDiagnostics,
    BaseCausalSample,
    GeneratorAlgebra,
    construct_base_sample,
    degree_two_generator_algebra,
    evaluate_algebra,
    johnston_coordinates,
    operator_for_setting,
    order_depth_region,
    random_coordinates,
)
from causal_operator_metric import signature
from causal_operator_weak_geometry import potential_free_operator


@dataclass(frozen=True)
class ProjectedWeakDiagnostics:
    sector: str
    chart: str
    events: int
    evaluation_count: int
    deepest_orbit_count: int
    envelope_rank: int
    gl_envelope_projector_error: float
    strong_operator_closure_defect: float
    strong_gamma_closure_defect: float
    strong_double_multiplication_defect: float
    strong_triple_commutator_defect: float
    weak_double_multiplication_defect: float
    weak_triple_commutator_defect: float
    weak_metric_signature: tuple[int, int, int]
    weak_metric_condition: float | None
    weak_hessian_norm: float
    weak_gamma2_norm: float
    weak_ricci_norm: float | None
    weak_ricci_cancellation_residual: float | None
    weak_scalar_curvature: float | None


def deepest_event_orbit(
    relation: np.ndarray,
    evaluation_mask: np.ndarray,
) -> np.ndarray:
    """Return every evaluation event of maximal two-sided causal depth."""

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if evaluation_mask.shape != (len(relation),) or not np.any(evaluation_mask):
        raise ValueError("evaluation mask must be nonempty and match the relation")
    past = np.count_nonzero(relation, axis=0)
    future = np.count_nonzero(relation, axis=1)
    depth = np.minimum(past, future)
    maximum = np.max(depth[evaluation_mask])
    return evaluation_mask & (depth == maximum)


def quadratic_coordinate_chart(
    coordinates: np.ndarray,
    quadratic_jet: np.ndarray,
) -> np.ndarray:
    """Apply ``y^a = u^a + Q^a_mn u^m u^n / 2`` to event coordinates."""

    values = np.asarray(coordinates, dtype=float)
    jet = np.asarray(quadratic_jet, dtype=float)
    if values.ndim != 2 or values.shape[1] != 4:
        raise ValueError("coordinates must have shape (N, 4)")
    if jet.shape != (4, 4, 4):
        raise ValueError("quadratic jet must have shape (4,4,4)")
    if not np.allclose(jet, np.swapaxes(jet, 1, 2)):
        raise ValueError("quadratic jet must be symmetric in its lower indices")
    return values + 0.5 * np.einsum("amn,im,in->ia", jet, values, values)


def oracle_chart_sectors(points: np.ndarray) -> dict[str, np.ndarray]:
    temporal = np.zeros((4, 4, 4))
    temporal[0, 0, 0] = 0.8
    shear = np.zeros((4, 4, 4))
    shear[0, 1, 1] = 1.5
    return {
        "affine": points,
        "temporal_quadratic": quadratic_coordinate_chart(points, temporal),
        "shear_quadratic": quadratic_coordinate_chart(points, shear),
    }


def project_fields(
    algebra: GeneratorAlgebra,
    fields: np.ndarray,
    evaluation_mask: np.ndarray,
) -> np.ndarray:
    """Project one or more full-carrier fields into the degree-two envelope."""

    values = np.asarray(fields, dtype=float)
    was_vector = values.ndim == 1
    if was_vector:
        values = values[:, None]
    if values.ndim != 2 or values.shape[0] != len(evaluation_mask):
        raise ValueError("fields must have one row per event")
    basis = algebra.envelope_basis
    coefficients = basis[evaluation_mask].T @ values[evaluation_mask]
    projected = basis @ coefficients
    return projected[:, 0] if was_vector else projected


def weak_box_batch(
    box: np.ndarray,
    algebra: GeneratorAlgebra,
    fields: np.ndarray,
    evaluation_mask: np.ndarray,
) -> np.ndarray:
    values = np.asarray(fields, dtype=float)
    if values.ndim == 1:
        values = values[:, None]
    return project_fields(algebra, box @ values, evaluation_mask)


def weak_gamma_batch(
    box: np.ndarray,
    algebra: GeneratorAlgebra,
    left: np.ndarray,
    right: np.ndarray,
    evaluation_mask: np.ndarray,
) -> np.ndarray:
    left_values = np.asarray(left, dtype=float)
    right_values = np.asarray(right, dtype=float)
    if left_values.ndim == 1:
        left_values = left_values[:, None]
    if right_values.ndim == 1:
        right_values = right_values[:, None]
    if left_values.shape != right_values.shape:
        raise ValueError("weak Gamma batches must have equal shapes")
    raw = 0.5 * (
        box @ (left_values * right_values)
        - left_values * (box @ right_values)
        - right_values * (box @ left_values)
    )
    return project_fields(algebra, raw, evaluation_mask)


def projected_commutator_defects(
    box: np.ndarray,
    algebra: GeneratorAlgebra,
    evaluation_mask: np.ndarray,
) -> tuple[float, float]:
    """Compute double/triple defects after weak projection to the algebra."""

    generators = algebra.generator_basis
    event_count, generator_count = generators.shape
    test_fields = np.column_stack((np.ones(event_count), generators))
    test_count = test_fields.shape[1]
    all_inputs = np.column_stack(
        (
            test_fields,
            *[
                generators[:, index, None] * test_fields
                for index in range(generator_count)
            ],
        )
    )
    basis_on_region = algebra.envelope_basis[evaluation_mask]

    double_actual: list[np.ndarray] = []
    double_expected: list[np.ndarray] = []
    triple_values: list[np.ndarray] = []
    triple_references: list[np.ndarray] = []
    for left in range(generator_count):
        left_delta = (
            generators[:, left][None, :] - generators[:, left][:, None]
        )
        for right in range(generator_count):
            right_delta = (
                generators[:, right][None, :]
                - generators[:, right][:, None]
            )
            kernel = box * left_delta * right_delta
            actions = kernel @ all_inputs
            base = actions[:, :test_count]
            gamma = 0.5 * (kernel @ np.ones(event_count))
            expected = 2.0 * gamma[:, None] * test_fields
            double_actual.append(basis_on_region.T @ base[evaluation_mask])
            double_expected.append(basis_on_region.T @ expected[evaluation_mask])
            for third in range(generator_count):
                start = test_count * (third + 1)
                stop = start + test_count
                acted_product = actions[:, start:stop]
                multiplied_action = generators[:, third, None] * base
                triple = acted_product - multiplied_action
                triple_values.append(basis_on_region.T @ triple[evaluation_mask])
                triple_references.extend(
                    [
                        basis_on_region.T @ acted_product[evaluation_mask],
                        basis_on_region.T @ multiplied_action[evaluation_mask],
                    ]
                )

    actual_stack = np.concatenate(double_actual, axis=1)
    expected_stack = np.concatenate(double_expected, axis=1)
    double_denominator = max(
        1.0e-14,
        float(np.linalg.norm(actual_stack, ord="fro")),
        float(np.linalg.norm(expected_stack, ord="fro")),
    )
    double_defect = float(
        np.linalg.norm(actual_stack - expected_stack, ord="fro")
        / double_denominator
    )
    triple_stack = np.concatenate(triple_values, axis=1)
    reference_norm_sq = sum(
        float(np.linalg.norm(value, ord="fro")) ** 2
        for value in triple_references
    )
    triple_defect = float(
        np.linalg.norm(triple_stack, ord="fro")
        / max(1.0e-14, np.sqrt(reference_norm_sq))
    )
    return double_defect, triple_defect


def projected_weak_readout(
    operator: np.ndarray,
    algebra: GeneratorAlgebra,
    evaluation_mask: np.ndarray,
    orbit_mask: np.ndarray,
) -> dict[str, object]:
    """Construct projected weak metric, Hessian, Gamma2, and Ricci readouts."""

    box = potential_free_operator(operator)
    generators = algebra.generator_basis
    generator_count = generators.shape[1]

    pair_left = np.column_stack(
        [generators[:, left] for left in range(generator_count) for _ in range(generator_count)]
    )
    pair_right = np.column_stack(
        [generators[:, right] for _ in range(generator_count) for right in range(generator_count)]
    )
    gamma_flat = weak_gamma_batch(
        box, algebra, pair_left, pair_right, evaluation_mask
    )
    gamma = gamma_flat.reshape(len(operator), generator_count, generator_count)
    weak_box_generators = weak_box_batch(
        box, algebra, generators, evaluation_mask
    )

    nested_left = np.column_stack(
        [
            generators[:, probe]
            for probe in range(generator_count)
            for _function in range(generator_count)
            for _other in range(generator_count)
        ]
    )
    nested_right = np.column_stack(
        [
            gamma[:, function, other]
            for _probe in range(generator_count)
            for function in range(generator_count)
            for other in range(generator_count)
        ]
    )
    nested = weak_gamma_batch(
        box, algebra, nested_left, nested_right, evaluation_mask
    ).reshape(
        len(operator), generator_count, generator_count, generator_count
    )
    hessian = np.empty(
        (len(operator), generator_count, generator_count, generator_count),
        dtype=float,
    )
    for function in range(generator_count):
        for first in range(generator_count):
            for second in range(generator_count):
                hessian[:, function, first, second] = 0.5 * (
                    nested[:, first, function, second]
                    + nested[:, second, function, first]
                    - nested[:, function, first, second]
                )

    weak_box_gamma = weak_box_batch(
        box, algebra, gamma_flat, evaluation_mask
    ).reshape(len(operator), generator_count, generator_count)
    gamma_box_flat = weak_gamma_batch(
        box,
        algebra,
        pair_left,
        np.column_stack(
            [
                weak_box_generators[:, right]
                for _left in range(generator_count)
                for right in range(generator_count)
            ]
        ),
        evaluation_mask,
    )
    gamma_box = gamma_box_flat.reshape(
        len(operator), generator_count, generator_count
    )
    gamma2 = np.empty_like(gamma)
    for left in range(generator_count):
        for right in range(generator_count):
            gamma2[:, left, right] = 0.5 * (
                weak_box_gamma[:, left, right]
                - gamma_box[:, left, right]
                - gamma_box[:, right, left]
            )

    metric_at_orbit = np.mean(gamma[orbit_mask], axis=0)
    metric_at_orbit = 0.5 * (metric_at_orbit + metric_at_orbit.T)
    hessian_at_orbit = np.mean(hessian[orbit_mask], axis=0)
    gamma2_at_orbit = np.mean(gamma2[orbit_mask], axis=0)
    gamma2_at_orbit = 0.5 * (gamma2_at_orbit + gamma2_at_orbit.T)
    metric_signature = signature(metric_at_orbit)
    metric_condition = None
    ricci_norm = None
    ricci_residual = None
    scalar_curvature = None

    if metric_signature == (1, 3, 0):
        metric_condition = float(np.linalg.cond(metric_at_orbit))
        covariant_metric = np.linalg.inv(metric_at_orbit)
        hessian_inner = np.empty_like(metric_at_orbit)
        for left in range(generator_count):
            for right in range(generator_count):
                hessian_inner[left, right] = np.einsum(
                    "ik,jl,ij,kl->",
                    covariant_metric,
                    covariant_metric,
                    hessian_at_orbit[left],
                    hessian_at_orbit[right],
                )
        ricci = gamma2_at_orbit - hessian_inner
        ricci = 0.5 * (ricci + ricci.T)
        ricci_norm = float(np.linalg.norm(ricci, ord="fro"))
        denominator = max(
            float(np.linalg.norm(gamma2_at_orbit, ord="fro")),
            float(np.linalg.norm(hessian_inner, ord="fro")),
        )
        ricci_residual = 0.0 if denominator <= 1.0e-10 else ricci_norm / denominator
        scalar_curvature = float(np.einsum("ab,ab->", covariant_metric, ricci))

    return {
        "metric_signature": metric_signature,
        "metric_condition": metric_condition,
        "hessian_norm": float(np.linalg.norm(hessian_at_orbit)),
        "gamma2_norm": float(np.linalg.norm(gamma2_at_orbit, ord="fro")),
        "ricci_norm": ricci_norm,
        "ricci_cancellation_residual": ricci_residual,
        "scalar_curvature": scalar_curvature,
    }


def evaluate_projected_sector(
    sector: str,
    chart: str,
    coordinates: np.ndarray,
    sample: BaseCausalSample,
    operator: np.ndarray,
    evaluation_mask: np.ndarray,
) -> ProjectedWeakDiagnostics:
    strong: AlgebraDiagnostics = evaluate_algebra(
        sector, coordinates, operator, evaluation_mask
    )
    algebra = degree_two_generator_algebra(coordinates, evaluation_mask)
    orbit = deepest_event_orbit(sample.relation, evaluation_mask)
    box = potential_free_operator(operator)
    weak_double, weak_triple = projected_commutator_defects(
        box, algebra, evaluation_mask
    )
    weak = projected_weak_readout(
        operator, algebra, evaluation_mask, orbit
    )
    return ProjectedWeakDiagnostics(
        sector=sector,
        chart=chart,
        events=len(operator),
        evaluation_count=int(np.count_nonzero(evaluation_mask)),
        deepest_orbit_count=int(np.count_nonzero(orbit)),
        envelope_rank=strong.envelope_rank,
        gl_envelope_projector_error=strong.gl_envelope_projector_error,
        strong_operator_closure_defect=strong.operator_closure_defect,
        strong_gamma_closure_defect=strong.gamma_closure_defect,
        strong_double_multiplication_defect=strong.double_multiplication_defect,
        strong_triple_commutator_defect=strong.triple_commutator_defect,
        weak_double_multiplication_defect=weak_double,
        weak_triple_commutator_defect=weak_triple,
        weak_metric_signature=weak["metric_signature"],
        weak_metric_condition=weak["metric_condition"],
        weak_hessian_norm=weak["hessian_norm"],
        weak_gamma2_norm=weak["gamma2_norm"],
        weak_ricci_norm=weak["ricci_norm"],
        weak_ricci_cancellation_residual=weak["ricci_cancellation_residual"],
        weak_scalar_curvature=weak["scalar_curvature"],
    )


def _finite_median(values: list[float | None]) -> float | None:
    finite = [value for value in values if value is not None and np.isfinite(value)]
    return None if not finite else float(np.median(finite))


def summarize_projected(
    samples: list[ProjectedWeakDiagnostics],
) -> dict[str, object]:
    if not samples:
        raise ValueError("cannot summarize no projected samples")
    result: dict[str, object] = {
        "sample_count": len(samples),
        "rank_15_rate": sum(sample.envelope_rank == 15 for sample in samples)
        / len(samples),
        "gl_envelope_projector_error_max": max(
            sample.gl_envelope_projector_error for sample in samples
        ),
        "weak_lorentzian_rate": sum(
            sample.weak_metric_signature == (1, 3, 0) for sample in samples
        )
        / len(samples),
    }
    scalar_names = (
        "strong_operator_closure_defect",
        "strong_gamma_closure_defect",
        "strong_double_multiplication_defect",
        "strong_triple_commutator_defect",
        "weak_double_multiplication_defect",
        "weak_triple_commutator_defect",
        "weak_hessian_norm",
        "weak_gamma2_norm",
        "weak_ricci_norm",
        "weak_ricci_cancellation_residual",
        "weak_scalar_curvature",
        "weak_metric_condition",
    )
    for name in scalar_names:
        result[f"{name}_median"] = _finite_median(
            [getattr(sample, name) for sample in samples]
        )
    return result


def _setting_key(c_l: float, fraction: float) -> str:
    return f"cL={c_l:.6f}|fraction={fraction:.6f}"


def _development_score(summary: dict[str, object]) -> tuple[float, ...]:
    return (
        float("inf")
        if summary["weak_ricci_cancellation_residual_median"] is None
        else float(summary["weak_ricci_cancellation_residual_median"]),
        float(summary["weak_triple_commutator_defect_median"]),
        float(summary["weak_double_multiplication_defect_median"]),
        float(summary["strong_gamma_closure_defect_median"]),
    )


def run_development(args: argparse.Namespace) -> dict[str, object]:
    seeds = np.random.SeedSequence(args.seed).spawn(
        len(args.events) * args.realizations
    )
    bases: dict[tuple[int, int], BaseCausalSample] = {}
    index = 0
    for events in args.events:
        for realization in range(args.realizations):
            bases[(events, realization)] = construct_base_sample(
                np.random.default_rng(seeds[index]),
                events,
                args.duration,
                args.dimension,
                args.block_size,
            )
            index += 1

    settings: dict[str, object] = {}
    for c_l in args.nonlocality_multipliers:
        operators = {
            key: operator_for_setting(base, args.duration, c_l)[0]
            for key, base in bases.items()
        }
        for fraction in args.retained_fractions:
            by_chart: dict[str, dict[str, list[ProjectedWeakDiagnostics]]] = {
                chart: {str(events): [] for events in args.events}
                for chart in oracle_chart_sectors(next(iter(bases.values())).points)
            }
            for events in args.events:
                for realization in range(args.realizations):
                    base = bases[(events, realization)]
                    mask = order_depth_region(
                        base.relation, fraction, args.minimum_evaluation_events
                    )
                    for chart, coordinates in oracle_chart_sectors(base.points).items():
                        by_chart[chart][str(events)].append(
                            evaluate_projected_sector(
                                "oracle", chart, coordinates, base,
                                operators[(events, realization)], mask
                            )
                        )
            summaries = {
                chart: {
                    events: summarize_projected(samples)
                    for events, samples in by_density.items()
                }
                for chart, by_density in by_chart.items()
            }
            all_samples = [
                sample
                for by_density in by_chart.values()
                for samples in by_density.values()
                for sample in samples
            ]
            structural = all(
                sample.envelope_rank == 15
                and sample.weak_metric_signature == (1, 3, 0)
                for sample in all_samples
            ) and all(
                sample.weak_hessian_norm > 1.0e-10
                for chart, by_density in by_chart.items()
                if chart != "affine"
                for samples in by_density.values()
                for sample in samples
            )
            worst_score = tuple(
                max(
                    _development_score(summary)[component]
                    for by_density in summaries.values()
                    for summary in by_density.values()
                )
                for component in range(4)
            )
            key = _setting_key(c_l, fraction)
            settings[key] = {
                "nonlocality_multiplier": c_l,
                "retained_fraction": fraction,
                "structural_pass": structural,
                "worst_score": worst_score,
                "summaries": summaries,
                "samples": {
                    chart: {
                        events: [asdict(sample) for sample in samples]
                        for events, samples in by_density.items()
                    }
                    for chart, by_density in by_chart.items()
                },
            }

    selected_key = min(
        settings,
        key=lambda key: (
            not bool(settings[key]["structural_pass"]),
            *[float(value) for value in settings[key]["worst_score"]],
            float(settings[key]["nonlocality_multiplier"]),
            float(settings[key]["retained_fraction"]),
        ),
    )
    return {
        "status": "oracle-only A40 projected weak-calculus development",
        "phase": "development",
        "calibration": {
            "seed": args.seed,
            "events": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "minimum_evaluation_events": args.minimum_evaluation_events,
            "nonlocality_multipliers": args.nonlocality_multipliers,
            "retained_fractions": args.retained_fractions,
        },
        "selected_setting": selected_key,
        "selection": settings[selected_key],
        "settings": settings,
    }


def _load_setting(path: Path) -> tuple[float, float, int]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    if payload.get("phase") != "development":
        raise ValueError("development artifact has wrong phase")
    selection = payload["selection"]
    return (
        float(selection["nonlocality_multiplier"]),
        float(selection["retained_fraction"]),
        int(payload["calibration"]["seed"]),
    )


def _value(summary: dict[str, object], name: str) -> float:
    value = summary[name]
    return float("inf") if value is None else float(value)


def heldout_pass_summary(
    summaries: dict[str, dict[str, dict[str, object]]],
    low_events: int,
    high_events: int,
) -> dict[str, object]:
    structural = all(
        summaries[sector][str(events)]["rank_15_rate"] == 1.0
        and summaries[sector][str(events)]["gl_envelope_projector_error_max"]
        < 1.0e-10
        for sector in summaries
        if sector != "random"
        for events in (low_events, high_events)
    )
    oracle_names = (
        "oracle_affine",
        "oracle_temporal_quadratic",
        "oracle_shear_quadratic",
    )
    oracle_signature = all(
        summaries[name][str(events)]["weak_lorentzian_rate"] >= 0.75
        for name in oracle_names
        for events in (low_events, high_events)
    )
    nonlinear_hessian = all(
        _value(summaries[name][str(events)], "weak_hessian_norm_median")
        > 1.0e-10
        for name in oracle_names[1:]
        for events in (low_events, high_events)
    )
    oracle_high_ricci = all(
        _value(
            summaries[name][str(high_events)],
            "weak_ricci_cancellation_residual_median",
        )
        < 0.50
        for name in oracle_names
    )
    low_worst = max(
        _value(
            summaries[name][str(low_events)],
            "weak_ricci_cancellation_residual_median",
        )
        for name in oracle_names
    )
    high_worst = max(
        _value(
            summaries[name][str(high_events)],
            "weak_ricci_cancellation_residual_median",
        )
        for name in oracle_names
    )
    oracle_ricci_refinement = high_worst < low_worst
    weak_beats_strong = all(
        _value(
            summaries[name][str(events)],
            "weak_double_multiplication_defect_median",
        )
        < _value(
            summaries[name][str(events)],
            "strong_double_multiplication_defect_median",
        )
        and _value(
            summaries[name][str(events)],
            "weak_triple_commutator_defect_median",
        )
        < _value(
            summaries[name][str(events)],
            "strong_triple_commutator_defect_median",
        )
        for name in oracle_names
        for events in (low_events, high_events)
    )
    weak_high_threshold = all(
        _value(
            summaries[name][str(high_events)],
            "weak_double_multiplication_defect_median",
        )
        < 0.50
        and _value(
            summaries[name][str(high_events)],
            "weak_triple_commutator_defect_median",
        )
        < 0.50
        for name in oracle_names
    )
    johnston = summaries["johnston"][str(high_events)]
    random = summaries["random"][str(high_events)]
    johnston_signature = johnston["weak_lorentzian_rate"] >= 0.75
    johnston_ricci = _value(
        johnston, "weak_ricci_cancellation_residual_median"
    ) < 0.75
    comparison_names = (
        "strong_gamma_closure_defect_median",
        "weak_double_multiplication_defect_median",
        "weak_triple_commutator_defect_median",
        "weak_ricci_cancellation_residual_median",
    )
    johnston_beats_random = all(
        _value(johnston, name) < _value(random, name)
        for name in comparison_names
    )
    heldout_pass = all(
        (
            structural,
            oracle_signature,
            nonlinear_hessian,
            oracle_high_ricci,
            oracle_ricci_refinement,
            weak_beats_strong,
            weak_high_threshold,
            johnston_signature,
            johnston_ricci,
            johnston_beats_random,
        )
    )
    return {
        "structural_pass": structural,
        "oracle_signature_pass": oracle_signature,
        "nonlinear_hessian_pass": nonlinear_hessian,
        "oracle_high_density_ricci_pass": oracle_high_ricci,
        "oracle_low_density_worst_ricci": low_worst,
        "oracle_high_density_worst_ricci": high_worst,
        "oracle_ricci_refinement_pass": oracle_ricci_refinement,
        "weak_beats_strong_pass": weak_beats_strong,
        "weak_high_density_threshold_pass": weak_high_threshold,
        "johnston_signature_pass": johnston_signature,
        "johnston_ricci_pass": johnston_ricci,
        "johnston_beats_random_pass": johnston_beats_random,
        "heldout_pass": heldout_pass,
    }


def run_heldout(args: argparse.Namespace) -> dict[str, object]:
    if args.development_artifact is None:
        raise ValueError("heldout phase requires --development-artifact")
    c_l, fraction, development_seed = _load_setting(args.development_artifact)
    if args.seed == development_seed:
        raise ValueError("heldout seed must differ from development seed")
    if len(args.events) != 2:
        raise ValueError("heldout logic requires exactly two densities")

    sector_names = (
        "oracle_affine",
        "oracle_temporal_quadratic",
        "oracle_shear_quadratic",
        "johnston",
        "random",
    )
    raw = {
        sector: {str(events): [] for events in args.events}
        for sector in sector_names
    }
    seeds = np.random.SeedSequence(args.seed).spawn(
        len(args.events) * args.realizations
    )
    index = 0
    for events in args.events:
        for realization in range(args.realizations):
            base = construct_base_sample(
                np.random.default_rng(seeds[index]),
                events,
                args.duration,
                args.dimension,
                args.block_size,
            )
            operator = operator_for_setting(base, args.duration, c_l)[0]
            mask = order_depth_region(
                base.relation, fraction, args.minimum_evaluation_events
            )
            for chart, coordinates in oracle_chart_sectors(base.points).items():
                raw[f"oracle_{chart}"][str(events)].append(
                    evaluate_projected_sector(
                        "oracle", chart, coordinates, base, operator, mask
                    )
                )
            raw["johnston"][str(events)].append(
                evaluate_projected_sector(
                    "johnston", "johnston",
                    johnston_coordinates(base, args.duration, args.dimension),
                    base, operator, mask
                )
            )
            random_rng = np.random.default_rng(
                np.random.SeedSequence([args.seed, events, realization, 40])
            )
            raw["random"][str(events)].append(
                evaluate_projected_sector(
                    "random", "random",
                    random_coordinates(random_rng, events, args.dimension),
                    base, operator, mask
                )
            )
            index += 1

    summaries = {
        sector: {
            events: summarize_projected(samples)
            for events, samples in by_density.items()
        }
        for sector, by_density in raw.items()
    }
    pass_summary = heldout_pass_summary(
        summaries, min(args.events), max(args.events)
    )
    return {
        "status": "conditional A40 projected weak-calculus audit; not curvature convergence",
        "phase": "heldout",
        "calibration": {
            "seed": args.seed,
            "development_seed": development_seed,
            "events": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "nonlocality_multiplier": c_l,
            "retained_fraction": fraction,
            "minimum_evaluation_events": args.minimum_evaluation_events,
        },
        "summaries": summaries,
        "pass_summary": pass_summary,
        "samples": {
            sector: {
                events: [asdict(sample) for sample in samples]
                for events, samples in by_density.items()
            }
            for sector, by_density in raw.items()
        },
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--phase", choices=("development", "heldout"), required=True)
    parser.add_argument("--events", type=int, nargs="+", default=[300, 600])
    parser.add_argument("--realizations", type=int, default=2)
    parser.add_argument("--duration", type=float, default=2.0)
    parser.add_argument("--dimension", type=int, default=4)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--minimum-evaluation-events", type=int, default=30)
    parser.add_argument(
        "--nonlocality-multipliers", type=float, nargs="+", default=[0.45, 0.60, 0.75]
    )
    parser.add_argument(
        "--retained-fractions", type=float, nargs="+", default=[0.15, 0.25, 0.35]
    )
    parser.add_argument("--seed", type=int, required=True)
    parser.add_argument("--development-artifact", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if args.realizations <= 0:
        raise ValueError("realizations must be positive")
    if args.dimension != 4:
        raise ValueError("this benchmark is convention-locked to dimension four")
    result = run_development(args) if args.phase == "development" else run_heldout(args)
    args.output.write_text(
        json.dumps(result, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )


if __name__ == "__main__":
    main()
